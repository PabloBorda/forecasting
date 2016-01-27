load 'Company.rb'

require 'date'
require 'json'
require 'rubygems'
require 'mongo'

include Forecasting

class Accucheck
  
  include Mongo
  
  @db
  
  def initialize(symbol)
    @db  = Mongo::Client.new([ 'localhost:27017' ], :database => 'alphabrokers')   
  end
  
  
  
  def run
    @db['Forecasts'].find().each do
      |f|
      puts f[:symbol_name].to_s
      
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end

