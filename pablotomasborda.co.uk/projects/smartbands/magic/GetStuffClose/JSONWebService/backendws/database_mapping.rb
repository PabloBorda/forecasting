# Run this before running the web service
#  export DATABASE_URL=mysql://root:justice@soa1.getstuffclose.com:3306/storemessages
# To grant access: GRANT ALL ON storemessages.* TO root@'getstuffclose.com' IDENTIFIED BY 'justice';

require 'sinatra'
require 'sinatra/activerecord'
load 'installer.rb'

set :database, 'mysql2://root:justice@soa1.smartbands.com.ar:3306/delivery'



=begin
 
 database_urls = {
    :development => 'sqlite://custom-dev.db'
    :production     => 'sqlite://custom-production.db',
    :test       => 'sqlite://custom-test.db'
 }
 set :database, database_urls[settings.environment]
 
=end

class Product < ActiveRecord::Base
  belongs_to :company
  belongs_to :category
  belongs_to :superproduct
  has_many :pictures
end

class Picture < ActiveRecord::Base
  belongs_to :product
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
  belongs_to :address
  belongs_to :account
  
  def charges_less_than (store)
    puts Company.find_by_id(Store.company_id).products.to_s    
  end
  
end

class Superproduct < ActiveRecord::Base
  has_one :product
end

class Account < ActiveRecord::Base
  has_one :company
  #has_one :account
end

class Message < ActiveRecord::Base
  belongs_to :address    
end

class Address < ActiveRecord::Base
  has_one :store
  has_many :messages
end

