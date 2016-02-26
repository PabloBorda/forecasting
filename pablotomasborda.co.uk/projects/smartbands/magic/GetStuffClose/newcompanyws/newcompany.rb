# Run this before running the web service
#  export DATABASE_URL=mysql://root:justice@dev.getstuffclose.com:3306/delivery
# To grant access: GRANT ALL ON delivery.* TO root@'getstuffclose.com' IDENTIFIED BY 'justice';

require 'rubygems'

require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'sinatra/activerecord'
require 'json'
require 'active_record'
require 'rest_client'



class Company < ActiveRecord::Base
  has_many :stores
  has_many :products
  belongs_to  :account  
end

class Store < ActiveRecord::Base
  belongs_to :company
  belongs_to :address
  belongs_to :account
end

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

class Account < ActiveRecord::Base
  has_one :company
  #has_one :account
end

class Address < ActiveRecord::Base
  has_one :store
end




class NewCompanyWS < Sinatra::Base

  #set :sessions, true
  #set :foo, 'bar'
  get '/getcompany/:id' do
    Company.find_by_id(params[:id]).to_json
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
  
end


NewCompanyWS.run! :host => 'localhost', :port => 9090