load 'Company.rb'
load 'Chunk.rb'

require 'date'
require 'json'
require 'rubygems'
require 'mongo'
require 'bson'
require 'net/ssh/gateway'


include Forecasting

class Accucheck
  
  include Mongo
  
  @db
  @gateway
  
  def initialize
    @gateway = Net::SSH::Gateway.new('178.62.123.38', 'root', :password => 'alphabrokers')
    @gateway.open('178.62.123.38', 27017, 27018)
    
    @db  = Mongo::Client.new([ 'localhost:27018' ], :database => 'alphabrokers')   
      
    puts @db['alphabrokers'].find({}).limit(1).to_a.to_json
  end
  
  
  
  def run
    
    count = @db[:Forecasts].count()
    
    pages = (count/10).round
      
    page_size = 10
    
    
    pages.times.each do |i|
      @db[:Forecasts].find({}).skip(i*page_size).limit(page_size).to_a.each do |f|
        f_parsed = JSON.parse(f.to_json)     # convert BSON to_json and then parse the JSON into a plain ruby object
        f_last_quote = last_quote_from_symbol(f_parsed['symbol'])
        
        puts "Accucheck company " + f_parsed['symbol']
        
        f_parsed['forecasts'].each do |forecast|
          puts "AccuCheck for: " + forecast['algorithm_name']
          left_chunk_from_forecast_to_check = forecast['forecast']['previous_n_quotes_chunk']
          right_chunk_from_forecast_to_check = forecast['forecast']['next_n_quotes_chunk']
          puts left_chunk_from_forecast_to_check.inspect
          puts right_chunk_from_forecast_to_check.inspect  
            
                      
        end
      end                        
    end                        
    
  
  end
  
  
  
  private

    def last_quote_from_symbol(symbol)
      c = Company.new(symbol)
      #puts "FIRST HISTORY" + (c.last_quote).to_j
      return c.last_quote

    end  
  
  
  
  
  
  
  
  
  
  
end


ac = Accucheck.new 
ac.run

