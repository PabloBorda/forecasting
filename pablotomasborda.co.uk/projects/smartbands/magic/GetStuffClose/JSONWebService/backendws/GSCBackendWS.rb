#!/usr/bin/env ruby

# Making a Sinatra app respect UTF-8:
#
# 1.  At the top of your app file, set $KCODE to 'u'.
#     This ensures your regexps are in UTF-8 mode by default,
#     and #inspect will output UTF-8 chracters correctly.
#     This option is on by default as of Ruby 1.9.
#     For more information on the $KCODE setting, see:
#     http://blog.grayproductions.net/articles/the_kcode_variable_and_jcode_library
$KCODE = 'u' if RUBY_VERSION < '1.9'
 


require 'rubygems'

require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'json'
require 'set'
require 'rest_client'
require 'net/ssh'
require 'net/sftp'

load 'database_mapping.rb'


module Utilities

  require 'xmpp4r/client'
  include Jabber

  class JabberAdviser
  
    def initialize(jid,passwd)
      @jid = JID::new(jid)
      @passwd = passwd
      @cl = Client::new(jid)
            @cl.connect
            @cl.auth(passwd)
    end
    
    def advise(store_addr,message)
      @to = store_addr
      @subject = "New deliver request!"
      m = Jabber::Message::new(@to, message).set_type(:normal).set_id('1').set_subject(@subject)
      @cl.send m
    end
    
    
  end
end
  

class SuperproductsAndProducts
  def initialize
    @superp = ""
    @prods = []
  end
end

class GSCBackend < Sinatra::Base



# 2.  Set content-type with charset=utf-8 param (not the default setting.)
#     This ensures the browser will render utf-8 characters correctly.
#     A before filter is a good place to do this:
  before do
    content_type :json, 'charset' => 'utf-8'
  
  end

  enable :sessions
  @out = ""
  
  before do
   puts "before executed"
   #halt 503   
  end
  
  after do
    puts "method executed! "
  end
  
  
  
  # Given a company and a superproduct returns all products belonging to the company
  get '/products/bycompany/:company/:superproduct' do
    
    superp = Superproduct.find_by_name(params[:superproduct])
    
    if !superp.nil?
      superid = superp.id
      #puts "THIS IS " + superid
      companyid = Company.find_by_name(params[:company]).id
      Product.find_all_by_superproduct_id_and_company_id(superid,companyid).to_json
    else
      "[]"
    end
  end

  # Given a company returns all its products
  get '/products/bycompany/:company' do    
    companyid = Company.find_by_name(params[:company]).id
    if !companyid.nil?
      Product.find_all_by_company_id(companyid).to_json
    else
      "[]"
    end
  end
  
  # Given a company returns all its superproducts
  get '/superproducts/bycompany/:company' do        
    companyid = Company.find_by_name(params[:company]).id
    if !companyid.nil?
      prods = Product.find_all_by_company_id(companyid)
      s = Set.new
      prods.each do |p|
        s.add Superproduct.find_by_id(p.superproduct_id).name
      end
      s.to_json
    else
      "[]"
    end
  end  
  
  
  get '/products/allbysuperproductandcompany/:company' do
    companyid = Company.find_by_name(params[:company]).id
    if !companyid.nil?
      
      prods = Product.find_all_by_company_id(companyid,:group=>'superproduct_id,id')
      tmp = {}
      
      ((prods.group_by {|prod| prod.superproduct_id}).each_pair { |k,v| tmp[Superproduct.find_by_id(k.to_s).name.to_s] = v })
      tmp.to_json
    else
      "[]"
    end
    
  end
  
  
  #Given the storeid returns all the store products
  get '/products/bystore/:storeid' do
    
    store = Store.find_by_id(params[:storeid])
    if !store.nil?
      company_id = store.company_id
      puts "THIS IS " + companyid.to_s
      Product.find_all_by_company_id(companyid).to_json
    else
      "[]"
    end
    
  end
  
  
  get '/product/:productid' do
    p = Product.find_by_id(params[:productid])
    p[:pictures] = Picture.find_all_by_product_id(params[:productid])
    p.to_json
    
    
    
    
  end
  
  
  
   get '/stores/one_per_company/has_superprod/sorted_by_distance/sorted_by_price' do

     query = "SELECT closest_stores.id,products.name,if ((COUNT(products.company_id)<2),'showprod','showstore'),sum(products.price),closest_stores.company_id,companies.name,companies.logo,closest_stores.distance
              FROM
                (SELECT stores.id,stores.company_id, ( 3959 * acos( cos( radians(" + params[:lat].to_s + ") ) * 
                 cos( radians( lat ) ) * cos( radians( lng ) - 
                 radians(" + params[:lng].to_s + ") ) + 
                 sin ( radians (" + params[:lat].to_s + ") ) *
                 sin( radians( lat ) ) ) ) AS distance 
                 FROM (stores inner join addresses on stores.address_id = addresses.id) 
                 HAVING distance < 25 ORDER BY distance LIMIT 10) closest_stores, products,superproducts,companies
  
              WHERE (superproducts.name like '" + params[:superprod].to_s + "') and
                    (products.superproduct_id = superproducts.id) and
                    (products.company_id = closest_stores.company_id) and
                    (companies.id = products.company_id)
              group by company_id
              order by closest_stores.distance,sum(products.price)"
     
        @prods_result = ActiveRecord::Base.connection.execute(query)
        @prods_result.to_json
     
   end


    get '/products/samecompany' do

    puts params.to_s
    
    all_closer_products_by_closest_store_same_company = "SELECT products.id,closest_stores.id,closest_stores.company_id,closest_stores.distance
                                                        FROM
                                                        (SELECT stores.id,stores.company_id, ( 3959 * acos( cos( radians(" + params[:lat].to_s + ") ) * 
                                                                                               cos( radians( lat ) ) * cos( radians( lng ) - 
                                                                                               radians(" + params[:lng].to_s + ") ) + 
                                                                                               sin ( radians (" + params[:lat].to_s + ") ) *
                                                                                               sin( radians( lat ) ) ) ) AS distance 
                                                        FROM (stores inner join addresses on 
                                                             stores.address_id = addresses.id) 
                                                        HAVING distance < 25 ORDER BY distance LIMIT 10) closest_stores, products,superproducts
                                                        WHERE (superproducts.name='" + params[:superprod].to_s + "') and
                                                              (products.superproduct_id = superproducts.id) and
                                                              (products.company_id = closest_stores.company_id) and
                    (products.company_id = '" + params[:companyid] + "');"



    @prods_result = ActiveRecord::Base.connection.execute(all_closer_products_by_closest_store_same_company)
   
    erb :closest_products

  end

  
  
  
  
  
  #Given a superproduct, and your lat and lng location returns all closer products 
  get '/products/groupedbycompany' do

    puts params.to_s
    
    all_closer_products_by_closest_store_same_company = "SELECT products.id,closest_stores.id,closest_stores.company_id,closest_stores.distance
                                                        FROM
                                                        (SELECT stores.id,stores.company_id, ( 3959 * acos( cos( radians(" + params[:lat].to_s + ") ) * 
                                                                                               cos( radians( lat ) ) * cos( radians( lng ) - 
                                                                                               radians(" + params[:lng].to_s + ") ) + 
                                                                                               sin ( radians (" + params[:lat].to_s + ") ) *
                                                                                               sin( radians( lat ) ) ) ) AS distance 
                                                        FROM (stores inner join addresses on 
                                                             stores.address_id = addresses.id) 
                                                        HAVING distance < 25 ORDER BY distance LIMIT 10) closest_stores, products,superproducts
                                                        WHERE (superproducts.name='" + params[:superprod].to_s + "') and
                                                              (products.superproduct_id = superproducts.id) and
                                                              (products.company_id = closest_stores.company_id);"



    @prods_result = ActiveRecord::Base.connection.execute(all_closer_products_by_closest_store_same_company)
   
    erb :closest_products

  end
  
  
  get '/stores/:companyid' do
    Store.find_by_company_id(params[:companyid]).to_json
    
  end
  
  
  get '/company/:companyid' do
    Company.find_by_id(params[:companyid]).to_json
  end
  
  get '/superproducts*' do
    out = []
    Superproduct.find_by_sql("select id,name,Levenshtein('" + params[:term].to_s + "',name) as lev,rank from superproducts where ((name like \'" + params[:term].to_s + "%\') or (name like \'% " + params[:term].to_s + "%\')) and (length(name) >= length('" + params[:term].to_s + "')) order by lev,rank desc limit 5;").each do |s|
      out.push({:value => s.id.to_s,:label => s.name.to_s,:lev => s.lev.to_s,:rank => s.rank.to_s})
    end

  


#    Superproduct.where("name like '%" + params[:term] + "%'").limit(5).each do |s|
#      out.push({:value => s.id.to_s,:label => s.name.to_s})      
#    end
    out.to_json
  end
  
  get '/searchtags*' do
    out = []
    Superproduct.find_by_sql("select a.id,a.name,Levenshtein('" + params[:term].to_s + "',a.name) as lev,a.rank" +
                             " from" +
                             " ((select id,name,rank from superproducts) union (select id,name,orders from products)) a" +
                             " where ((a.name like '" + params[:term].to_s + "%') or (a.name like '% " + params[:term].to_s + "%')) and (length(a.name) >= length('" + params[:term].to_s + "'))" +
                             " order by lev,rank desc limit 5;").each do |s|
      out.push({:value => s.id.to_s,:label => s.name.to_s,:lev => s.lev.to_s,:rank => s.rank.to_s})
    end
    out.to_json
  end
  
  
  # Creates a new product from a facebook account
  get '/newproduct' do
    
    
    
  end
  
  
  get '/possible_location*' do
    RestClient.get("http://maps.googleapis.com/maps/api/geocode/json?latlng=" + params[:lat].to_s + "," + params[:lng].to_s + "&sensor=false").to_str
    
  end
  
  get '/geolocation/mobile/addresses*' do
    addr = params[:term]
    puts '---------------http://maps.googleapis.com/maps/api/geocode/json?address=' + addr.gsub(' ','%20') + '&sensor=false'
    uri = URI.parse 'http://maps.googleapis.com/maps/api/geocode/json?address=' + addr.gsub(' ','%20') + '&sensor=false'     
    @res = JSON.parse(Net::HTTP.get_response(uri).body.to_s)
    
    @jqmobile = []
    i = 0
    @res["results"].each do |v|
      @jqmobile.push({"value" => i.to_s,"label" => v["formatted_address"].to_s })
      i = i + 1
    end
    @jqmobile.to_json
    
  end
  

  
  get '/messages/:addr' do
    @address = params[:addr]
    @address_id = Address.find_by_address(@address)
    puts "I found the address " + @address_id.to_s
    @messages = Message.find_all_by_address_id(@address_id.id)
    #@messages.to_s
    erb :messages
  end
  
  post '/messages' do
    @address = params[:addr]
    @address_id = Address.find_by_address(@address)
    if !@address_id.nil?
      puts "I found the address " + @address_id.to_s
      @messages = Message.find_all_by_address_id(@address_id.id)
      #@messages.to_s
      erb :messages
    else
      "0"
    end
  end
  



  get '/getcompany/:id' do
    Company.find_by_id(params[:id]).to_json
  end


  get '/products/pic/:productname' do
    Pictures.find_by_product(Product.find_by_name(params[:productname])).to_json
  end


  post '/new_product_social*' do
    

    #puts "Parameters: " + params.to_s

    comp = Company.find_or_create_by_name(params["companyname"]) {
      |c|
      c.name = params["companyname"]
      c.logo = params["companylogo"]
      c.webpage = params["webpage"]
      c.account = Account.create(:account_type_id => 3,:user => params["companyname"],:password => params["password"],:email => params["email"])
      c.email = params["email"]
      c.enabled = true
    }    

    addr = Address.find_or_create_by_address(params["address"]) { 
      |a|
      a.lat = params["lat"]
      a.lng = params["lng"]
      a.address = params["address"]
    }
      
    account_store = Account.find_or_create_by_user_and_email((addr.lat.to_s + "-" + addr.lng.to_s),params["email"]) {
      |ac|
      ac.account_type_id = 1
      ac.password = (params["companyname"].gsub(" ",""))      
    }
      
    store = Store.new
    store.company = comp
    store.address = addr
    store.account = account_store
    store.open = true
    store.save
      
    puts store.to_s

    superproduct = Superproduct.find_or_create_by_name(:name => params["superproduct"])
      
    product = Product.find_or_create_by_name_and_price_and_company_id_and_superproduct_id_and_description(params["name"],params["price"],comp.id,superproduct.id,params["description"])

    pics = []
    params.each do |k,v|
      puts "Checking if " + k.to_s + " is a picture"
      if k.to_s.include? "pic"
        puts "Picture: " + k.to_s + " being uploaded."
        filename = k.to_s + "_" + params["time"] + ".jpg"
        file = params[k.to_s]

        File.open("uploads/" + filename.to_s , 'wb') {|f| f.write(file) }

        pic = Picture.new
        pic.url = "/" + filename
        pic.product = product
        pic.save
        #puts "Picture: " + k.to_s + " uploaded successfully"

        #Net::SFTP.start('dev.getstuffclose.com','root',:password => 'p0tat0l0c01') do |sftp|
          # upload a file or directory to the remote host
          #puts "UPLOADING!! " + filename
          #puts "UPLOADING!! " + params["companyname"]
          #sftp.upload!("uploads/" + filename + ".jpg", "/var/www/html/images" + params["companyname"].gsub!(" ",""))        
        #end
        pics.push("/" + filename)
      end
   end
   pics.to_json 
  end
    







  post '/newcompany' do
    #Create Company
    company = params[:CompanyData].gsub!("=>",":")
    puts company
    json_company = JSON.parse(company)
    
    
    account_db = Account.create(:account_type_id => 3,:user => json_company["company-name"],:password => json_company["password"],:email => json_company["email"])
    company_db = Company.new
    company_db.account = account_db
    company_db.name = json_company["company-name"]
    company_db.logo = json_company["company-logo"]
    company_db.webpage = json_company["webpage"]
    company_db.email = json_company["email"]
    company_db.enabled = true

    #company_db = Company.create(:name => json_company["company-name"],:webpage => json_company["webpage"],:email => json_company["email"])
    puts "||||||||||||||||| " + company_db.to_s
    puts "============================================="
    stores = params[:Stores].gsub!("=>",":")
   
    json_stores = JSON.parse(stores)
    json_stores.each do
      |s|
      puts "Processing Store: " + s.to_s
      addr = Address.new
      addr.lat = s[1]["lat"]
      addr.lng = s[1]["lon"]
      addr.address = s[1]["street"]
      addr.save
      account_store = Account.create(:account_type_id => 1,:user => (addr.lat.to_s + "-" + addr.lng.to_s),:password => (json_company["company-name"].gsub(" ","") + s[0]),:email => json_company["email"])
      
      store = Store.new
      store.company = company_db
      store.address = addr
      store.account = account_store
      store.open = true
      store.save
      
    end
    puts "============================================="
    products = params[:Products].gsub!("=>",":")
    
    json_products = JSON.parse(products)
    company_db.save

    json_products.each do
      |p|
      puts "Current product " + p.to_s
      superproduct = Superproduct.find_or_create_by_name(p[1]["superproduct"])
      pic = Picture.new
      pic.url = p[1]["productpic"]
      prod = Product.new
      prod.name = p[1]["name"]
      prod.price = p[1]["price"]
      prod.company = company_db
      prod.description = p[1]["description"]
      prod.superproduct = superproduct
      
      prod.save
      pic.product = prod
      pic.save
      
    end
    puts "============================================="
  #  puts newcompany
   # newcompany_parsed = JSON.parse(newcompany)
  #  puts newcompany_parsed

    
    
    
    erb :newcompany
  end
  
  get '/pictures/mkthumbs' do
    
  end


  #All neccesary data to render a single store. You pass the id and get store data, its products ith its pictures, categories...
  get '/store*' do
    s = Store.find_by_id(params[:storeid])
    c = Company.find_by_id(s.company_id)
 
    s[:products] = Product.find_all_by_company_id(s.company_id,:group=>'superproduct_id,id')

    s.products.each {|p| 
      p[:pictures] = Picture.find_all_by_product_id(p.id).collect {|pr| pr.url }
      puts "FOUND Pictures..."
    }

    s[:address] = Address.find_by_id(s.address_id).address

    s[:lat] = Address.find_by_id(s.address_id).lat

    s[:lng] = Address.find_by_id(s.address_id).lng
            
    s.products.each do |p|
      p.category = Category.find_by_id(p.category_id)
      p.superproduct = Superproduct.find_by_id(p.superproduct_id)
      


    end


    "[" + c.to_json + ",{" + s.to_json[1..-1] + "]"
  end




  get '/search_stores_for*' do
    results = []
    lat = params[:lat]
    lng = params[:lng]
    sprod = params[:superproduct]
    q ="SELECT closest_stores.id,companies.name,companies.logo,closest_stores.distance,closest_stores.lat,closest_stores.lng,closest_stores.company_id
              FROM
                (SELECT stores.id, stores.company_id, ( 3959 * ACOS( COS( RADIANS(" + params[:lat].to_s + " ) ) * COS( RADIANS( lat ) ) * COS( RADIANS( lng ) - RADIANS( " + params[:lng].to_s + " ) ) + SIN( RADIANS( " + params[:lat].to_s + " ) ) * SIN( RADIANS( lat ) ) ) ) AS distance,lat,lng
                 FROM stores, addresses
                 WHERE (stores.address_id = addresses.id)
                 GROUP BY stores.company_id
                 ORDER BY distance) closest_stores, products,superproducts,companies
              WHERE (LOWER(superproducts.name) like LOWER('" + params[:superproduct].to_s + "%')) and
                    (products.superproduct_id = superproducts.id) and
                    (products.company_id = closest_stores.company_id) and
                    (companies.id = products.company_id)
              group by closest_stores.company_id
              order by closest_stores.distance
              limit 20;"
    
    results = ActiveRecord::Base.connection.execute(q)
    results.to_json

  end


 
  get '/search*' do
     search = []
     psize = params[:psize].to_i
     pnum = params[:pnum].to_i
     
     query = "SELECT closest_stores.id,products.name,if ((COUNT(products.company_id)<2),'showprod','showstore'),sum(products.price),closest_stores.company_id,companies.name,companies.logo,closest_stores.distance,closest_stores.lat,closest_stores.lng,companies.usr_fcbk
              FROM
                (SELECT stores.id, stores.company_id, ( 3959 * ACOS( COS( RADIANS(" + params[:lat].to_s + " ) ) * COS( RADIANS( lat ) ) * COS( RADIANS( lng ) - RADIANS( " + params[:lng].to_s + " ) ) + SIN( RADIANS( " + params[:lat].to_s + " ) ) * SIN( RADIANS( lat ) ) ) ) AS distance,lat,lng
                 FROM stores, addresses
                 WHERE (stores.address_id = addresses.id)
                 GROUP BY stores.company_id
                 HAVING distance <25
                 ORDER BY distance) closest_stores, products,superproducts,companies
              WHERE (superproducts.name like '" + params[:superprod].to_s + "') and
                    (products.superproduct_id = superproducts.id) and
                    (products.company_id = closest_stores.company_id) and
                    (companies.id = products.company_id)
              group by company_id
              order by closest_stores.distance,sum(products.price)"
      if params[:psize]  || params[:pnum]
        query = query + " limit " + (pnum*psize).to_s + "," + ((psize)).to_s + ";"
      else
        query = query + ";"
      end
      puts query.to_s
       # uncached do     
      @prods_result = ActiveRecord::Base.connection.execute(query)
      @prods_result.each {|store|

          companyid = Company.find_by_name(store[5]).id
          if !companyid.nil?
      
            prods = Product.find_all_by_company_id(companyid,:group=>'superproduct_id,id')
            prods.each {|p| 

                p["pictures"] = Picture.find_all_by_product_id(p.id).collect {|pr| pr.url }
                puts "FOUND Pictures..."
              
           
            }
            
            
            tmp = {}
      
            ((prods.group_by {|prod| prod.superproduct_id}).each_pair { |k,v| tmp[Superproduct.find_by_id(k.to_s).name.to_s] = v })
            search.push({'store' => store,'products' => tmp })
          else
            search.push({'store' => store,'products' => [] })
          end
  
        }
       if !params[:psize] && !params[:pnum]
         {"amount" => search.size.to_s }.to_json
       else
         search.to_json
       end
      #end
  end
  
  
  
  
  post '/order' do
      ja = Utilities::JabberAdviser.new('smartbands@chat.smartbands.com.ar','smartbands')
      puts "=======================store" + session["companyid"] + "-" + cs + "@chat.getstuffclose.com"
      text_to_send = "Address: " + @street + "\nNumber: " + @number + "\nDepto: " + my_order.depto + products_str_for_message + "\nPhone: " + my_order.phone + "\nAmount: " + my_order.amount.to_s
      ja.advise("store" + session["companyid"] + "-" + cs + "@chat.getstuffclose.com",text_to_send)
  
  end
  
  get '/newxmpp' do
    command = "ejabberdctl register " + params["uid"].to_str + " chat.smartbands.com.ar " + params["uid"].to_str
    if ((`#{command}`).include? "successfully")
      "created"
    else
      "failed"
    end
  end  
  
  
  get '/submitproduct' do
	puts "============================================="

	acc = Account.find_or_create_by_user_and_email(params["nameaccount"],params["emailaccount"]) {
	   |ac|
           ac.account_type_id = 1
           ac.password = (params["nameaccount"].gsub(" ",""))      
	    ac.user_fcbk = 1
       }	

	comp = Company.find_or_create_by_name(params["nameaccount"]) {
	  |c|
         c.name = params["nameaccount"]
         c.logo = params["imgfcbkaccount"]
         c.webpage = params["webpageaccount"]
	  c.enabled = 1
	  c.email = params["emailaccount"]
         c.account_id = acc.id 
         c.usr_fcbk = 1
	}

	superprod = Superproduct.find_or_create_by_name(:name => params["superproduct"])

	product = Product.find_or_create_by_name_and_price_and_company_id_and_superproduct_id_and_description(params["nameproduct"],params["priceproduct"],comp.id ,superprod.id,params["descproduct"])

	add = Address.find_or_create_by_lat_and_lng(params["acclat"], params["acclng"]) {
	  |a|
         a.address = params["accaddress"]
	}

	puts add.to_s 

       store = Store.new
       store.company = comp
       store.address = add
       store.account = acc 
       store.open = true
	store.context_id = 261
       store.save

       puts store.to_s
	

	puts "============================================="
	

  end

end
GSCBackend.run! :host => 'localhost', :port => 9494



#  puts "Methods are " + GSCBackend.instance_values['routes']['GET'].each { |g| Aspects::Aspect.wrap(g[3],g[1],bf,[],af,[]) }
