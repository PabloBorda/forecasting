require "sinatra"
require "rubygems"

require "frankie"
require "mysql"
require "net/http"
require "uri"
require "json"





module MyApp < Sinatra::Base register Sinatra::Frankie configure do set_option :sessions, true load_facebook_config File.dirname(__FILE_) + “/config/facebooker.yml”, Sinatra::Application.environment end


facebooker helpers
  before do
    ensure_authenticated_to_facebook
    ensure_application_is_installed_by_facebook_user
  end
  
  get '/' do
    
    body “Hello #{session[:facebook_session].user.name} and welcome to frankie!”
  end
end

  




get '/whatproduct' do
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
                            