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

          pivot_quote_trade_date = forecast['forecast']['quote']['trade_date']
          left_chunk_from_forecast_to_check = forecast['forecast'][' previous_n_quotes_chunk']
          right_chunk_from_forecast_to_check = forecast['forecast'][' next_n_quotes_chunk']
          #puts "RIGHT: " + forecast['forecast'][' next_n_quotes_chunk'].inspect
          if !right_chunk_from_forecast_to_check.nil?
            forecasted_quote = right_chunk_from_forecast_to_check.find do
              |q|

              (q['trade_date'] == f_last_quote.trade_date)

            end

            #puts "forecasted_quote: " + forecasted_quote.inspect
            #puts "real quote value: " + f_last_quote.inspect

            accuracy_row = { :symbol => f_parsed['symbol'],
                             :algorithm => forecast['algorithm_name'],
                             :date => f_last_quote.trade_date, 
                             :real_quote => Quote.from_openstruct(f_last_quote).to_hash,
                             :forecasted_quote => Quote.from_openstruct(forecasted_quote).to_hash,
                             :difference => class_from_string(forecast['algorithm_name']).accucheck_me(Quote.from_openstruct(f_last_quote),Quote.from_openstruct(forecasted_quote)).to_hash 
            }
            
            #puts accuracy_row.to_json   
            
            @db[:Accuchecks].insert_one(accuracy_row)  # Here should go the mongo insert

          end

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
  
  def class_from_string(str)
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
  
  
  
  

end

ac = Accucheck.new
ac.run

