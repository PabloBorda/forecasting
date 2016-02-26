# Run this before running the web service
#  export DATABASE_URL=mysql://root:justice@soa1.getstuffclose.com:3306/storemessages
# To grant access: GRANT ALL ON storemessages.* TO root@'getstuffclose.com' IDENTIFIED BY 'justice';

require 'rubygems'

require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'json'
require 'sinatra/activerecord'
require 'active_record'
require 'set'
require 'rest_client'



class Product < ActiveRecord::Base
  belongs_to :company
  belongs_to :category
  belongs_to :superproduct
  has_many :pictures
end

class Picture < ActiveRecord::Base
  belongs_to :product
end


class Superproduct < ActiveRecord::Base
  has_one :product
end

class Category < ActiveRecord::Base
  has_one :product
end

class Company < ActiveRecord::Base
  has_many :stores
  has_many :products
  belongs_to  :account  
end

class Store < ActiveRecord::Base
  belongs_to :company

  def charges_less_than (store)
    puts Company.find_by_id(Store.company_id).products.to_s
    
    
    
  end


end


class SuperproductsAndProducts
  def initialize
    @superp = ""
    @prods = []
  end
end


class ProductsWS < Sinatra::Base

  #set :sessions, true
  #set :foo, 'bar'
  
#  def initialize
    
#  end
  
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
    Superproduct.where("name like '%" + params[:term] + "%'").limit(5).each do |s|
      out.push({:value => s.id.to_s,:label => s.name.to_s})      
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
  
end


ProductsWS.run! :host => 'localhost', :port => 9494