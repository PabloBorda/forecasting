require "sinatra"
require "mogli"
require "rubygems"
require "mysql"
require "net/http"
require "uri"
require "json"

enable :sessions
set :raise_errors, false
set :show_exceptions, false


# Scope defines what permissions that we are asking the user to grant.
# In this example, we are asking for the ability to publish stories
# about using the app, access to what the user likes, and to be able
# to use their pictures.  You should rewrite this scope with whatever
# permissions your app needs.
# See https://developers.facebook.com/docs/reference/api/permissions/
# for a full list of permissions
FACEBOOK_SCOPE = 'user_likes,user_photos,user_photo_video_tags'


ENV["FACEBOOK_APP_ID"] = '244377358952042'
ENV["FACEBOOK_SECRET"] = '9e83320518ef32c032e6fb54e66deeeb'


unless ENV["FACEBOOK_APP_ID"] && ENV["FACEBOOK_SECRET"]
  abort("missing env vars: please set FACEBOOK_APP_ID and FACEBOOK_SECRET with your app credentials")
end

before do
  # HTTPS redirect
  if settings.environment == :production && request.scheme != 'https'
    redirect "https://#{request.env['HTTP_HOST']}"
  end
  
  begin
   # connect to the MySQL server
   @dbh = Mysql.real_connect("dev.getstuffclose.com", "root", "justice", "delivery")
   # get server version string and display it
   puts "Server version: " + @dbh.get_server_info
   
  rescue Mysql::Error => e
   puts "Error code: #{e.errno}"
   puts "Error message: #{e.error}"
   puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
  end    
end

helpers do
  def url(path)
    base = "#{request.scheme}://#{request.env['HTTP_HOST']}"
    base + path
  end

  def post_to_wall_url
    "https://www.facebook.com/dialog/feed?redirect_uri=#{url("/close")}&display=popup&app_id=#{@app.id}";
  end

  def send_to_friends_url
    "https://www.facebook.com/dialog/send?redirect_uri=#{url("/close")}&display=popup&app_id=#{@app.id}&link=#{url('/')}";
  end

  def authenticator
    @authenticator ||= Mogli::Authenticator.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_SECRET"], url("/auth/facebook/callback"))
  end

  def first_column(item, collection)
    return ' class="first-column"' if collection.index(item)%4 == 0
  end
end

# the facebook session expired! reset ours and restart the process
error(Mogli::Client::HTTPException) do
  session[:at] = nil
  redirect "/auth/facebook"
end

get "/" do
  redirect "/auth/facebook" unless session[:at]
  @client = Mogli::Client.new(session[:at])

  # limit queries to 15 results
  @client.default_params[:limit] = 15

  @app  = Mogli::Application.find(ENV["FACEBOOK_APP_ID"], @client)
  @user = Mogli::User.find("me", @client)

  # access friends, photos and likes directly through the user instance
  @friends = @user.friends
  @photos  = @user.photos[0, 16]
  @likes   = @user.likes[0, 4]

  # for other data you can always run fql
  @friends_using_app = @client.fql_query("SELECT uid, name, is_app_user, pic_square FROM user WHERE uid in (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1")

  erb :index
end

# used by Canvas apps - redirect the POST to be a regular GET
post "/" do
  redirect "/"
end

# used to close the browser window opened to post to wall/send to friends
get "/close" do
  "<body onload='window.close();'/>"
end

get "/auth/facebook" do
  session[:at]=nil
  redirect authenticator.authorize_url(:scope => FACEBOOK_SCOPE, :display => 'page')
end

get '/auth/facebook/callback' do
  client = Mogli::Client.create_from_code_and_authenticator(params[:code], authenticator)
  session[:at] = client.access_token
  redirect '/'
end

get '/whatproduct' do
 @res = @dbh.query("select name from superproducts where name like '%" + params[:q] + "%' limit 10;") 
 erb :prods
end



get '/addrs' do
  
  uri = URI.parse 'http://maps.googleapis.com/maps/api/geocode/json?address=' + params[:q].gsub(' ','%20') + '&sensor=false'     
  addrs = Net::HTTP.get_response(uri).body
  jsonaddr = JSON(addrs)
  @out = ""
  (jsonaddr["results"].size).times do |i|
    @out = @out + jsonaddr["results"][i]["formatted_address"].to_s + "\n"
  end
  erb :addrs
  
end

get '/prods' do
   uri = URI.parse 'http://maps.googleapis.com/maps/api/geocode/json?address=' + URI.escape(params[:addr]).to_s + '&sensor=false'     
   addrs = Net::HTTP.get_response(uri).body
   jsonaddr = JSON(addrs)
   lat = jsonaddr["results"][0]["geometry"]["location"]["lat"].to_s
   lng = jsonaddr["results"][0]["geometry"]["location"]["lng"].to_s
   
   puts "LATITUDE: " + lat
   puts "LONGITUDE: " + lng
   
   
   all_closer_products_by_closest_store_same_company = "SELECT products.id,closest_stores.id,closest_stores.companies_id,closest_stores.distance
                                                        FROM
                                                        (SELECT stores.id,stores.companies_id, ( 3959 * acos( cos( radians(" + lat.to_s + ") ) * 
                                                                                               cos( radians( lat ) ) * cos( radians( lng ) - 
                                                                                               radians(" + lng.to_s + ") ) + 
                                                                                               sin ( radians (" + lat.to_s + ") ) *
                                                                                               sin( radians( lat ) ) ) ) AS distance 
                                                        FROM (stores inner join addresses on 
                                                             stores.addresses_id = addresses.id) 
                                                        HAVING distance < 25 ORDER BY distance LIMIT 10) closest_stores, products,superproducts
                                                        WHERE (superproducts.name='" + params[:superprod] + "') and
                                                              (products.superproduct_id = superproducts.id) and
                                                              (products.companies_id = closest_stores.companies_id);"
							      
							      
							      
   all_closer_products_by_closest_store_xamont_per_company = "SELECT products.id,closest_stores.id,closest_stores.companies_id,closest_stores.distance
                                                        FROM
                                                        (SELECT stores.id,stores.companies_id, ( 3959 * acos( cos( radians(" + lat.to_s + ") ) * 
                                                                                               cos( radians( lat ) ) * cos( radians( lng ) - 
                                                                                               radians(" + lng.to_s + ") ) + 
                                                                                               sin ( radians (" + lat.to_s + ") ) *
                                                                                               sin( radians( lat ) ) ) ) AS distance 
                                                        FROM (stores inner join addresses on 
                                                             stores.addresses_id = addresses.id) 
                                                        HAVING distance < 25 ORDER BY distance LIMIT 10) closest_stores, products,superproducts
                                                        WHERE (superproducts.name='" + params[:superprod] + "') and
                                                              (products.superproduct_id = superproducts.id) and
                                                              (products.companies_id = closest_stores.companies_id);" 
   
   
   
   
   @prods_result = @dbh.query(all_closer_products_by_closest_store_same_company)
   
   erb :closest_products

end


                            
                            
                            
                            