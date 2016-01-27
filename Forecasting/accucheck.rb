load 'Company.rb'

require 'date'
require 'json'
require 'rubygems'
require 'mongo'
require 'bson'

include Forecasting

class Accucheck
  
  include Mongo
  
  @db
  
  def initialize
    @db  = Mongo::Client.new([ 'localhost:27017' ], :database => 'alphabrokers')   
  end
  
  
  
  def run
    @db[:Forecasts].find({}).limit(10).to_a.each do
      |f|
      f_parsed = JSON.parse(f.to_json)
      f_last_quote = last_quote_from_symbol(f_parsed['symbol'])
      puts f_parsed['symbol'].to_s 
      puts f_last_quote.to_j
    end 
  
  end
  
  
  
  private

    def last_quote_from_symbol(symbol)
      c = Company.new(symbol)
      puts c.inspect
      return c.last_quote

    end  
  
  
  
  
  
  
  
  
  
  
end


ac = Accucheck.new 
ac.run

