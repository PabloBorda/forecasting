require_relative '../model/Company.rb'
require_relative '../model/Chunk.rb'
require_relative '../algorithms/Forecaster.rb'
require_relative '../algorithms/DeltaForecaster.rb'
require_relative '../algorithms/AvgForecaster.rb'
require_relative '../services/MongoConnector.rb'

require_relative "../services/QuoteService.rb"
require_relative "../model/Quote.rb"

require 'date'
require 'json'
require 'rubygems'
require 'mongo'
require 'bson'
require 'net/ssh/gateway'
require 'logger'

include Forecasting


class Accucheck

  
  include Forecasting
 

  @db
  @gateway
  @last_symbol
  @logger
  @instance
  @quotes_service
  
  
  def self.get_instance
    if @instance.nil?
      @quotes_service =  ::Forecasting::Services::QuoteService.get_instance
      @instance = Accucheck.new
    end
    @instance
  end
  
  
  
  def accuracy_per_algorithm_per_company

  end



  def run

    if @quotes_service.nil?
      @quotes_service =  ::Forecasting::Services::QuoteService.get_instance
    end
    
    count = @db[:Forecasts].count()

    insertion_counter = 0

    pages = (count/10).round

    page_size = 10

    pages.times.each do |i|
      @db[:Forecasts].find({}).skip(i*page_size).limit(page_size).to_a.each do |f|
        
        f_parsed = JSON.parse(f.to_json)     # convert BSON to_json and then parse the JSON into a plain ruby object
        
          
          puts "Accucheck company " + f_parsed['symbol']
          
          f_parsed['forecasts'].each do |forecast|
            puts "AccuCheck for: " + forecast['algorithm_name']
            pivot_quote_trade_date = forecast['forecast']['quote']['trade_date']
            left_chunk_from_forecast_to_check = forecast['forecast'][' previous_n_quotes_chunk']
            right_chunk_from_forecast_to_check = forecast['forecast'][' next_n_quotes_chunk']
              
            if !right_chunk_from_forecast_to_check.nil? and !right_chunk_from_forecast_to_check.first.nil?
              
              from_first_forecasted_quote_date = Time.strptime(right_chunk_from_forecast_to_check.first["trade_date"],'%Y-%m-%d')
              to_last_forecasted_quote_date = Time.strptime(right_chunk_from_forecast_to_check.last["trade_date"],'%Y-%m-%d')
            
              real_quotes = @quotes_service.all_history_between(f_parsed['symbol'],{ start_date: from_first_forecasted_quote_date, end_date: to_last_forecasted_quote_date })

              forecasted_quotes = right_chunk_from_forecast_to_check
            
              forecasted_quotes.each_with_index do 
                |q,i|

                existing_checks = @db[:Accuchecks].find({:symbol => f_parsed['symbol'],:date => q["trade_date"], :algorithm => forecast['algorithm_name'] }).to_a
                if (existing_checks.size == 0)
                  accu = build_accucheck(forecast['algorithm_name'],q,real_quotes[i])
                  puts "INSERTING: " + accu.inspect
                  if !accu.nil?
                    if insertion_counter == 0
                      @db[:Accuchecks].insert_one(accu)  # Here should go the mongo insert
                      insertion_counter = insertion_counter + 1
                    else
                      insertion_counter = 0
                    end
                    
                  else
                    puts "accu is NIL"
                  end
               
                else
                  puts "Accucheck already exists: " +  {:symbol => f_parsed['symbol'],:date => q["trade_date"], :algorithm => forecast['algorithm_name'] }.inspect 
                end
              end
            end
          end
        end
      end
    end


  

  private
  
  
  
  def initialize
   
    connector = ::Services::MongoConnector.get_instance

    @db  = connector.connect
    #puts "AMOUNT QUPOTES! " + @db.methods.inspect

    #@logger = Logger.new("../logs/accucheck.log")


  end

  def last_quote_from_symbol(symbol)
    c = Forecasting::Company.new(symbol)
    #puts "FIRST HISTORY" + (c.last_quote).to_j
    return c.last_quote

  end

  def class_from_string(str)
    
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
  
  
  def build_accucheck(algorithm_name,forecasted_quote,real_quote)
    difference = class_from_string(algorithm_name).accucheck_me(Quote.from_openstruct(real_quote),Quote.from_openstruct(forecasted_quote))
    #puts "DIFFERENCE! " + difference.inspect
    if !difference.nil?
    
       accuracy_row = { :symbol => real_quote['symbol'],
       :algorithm => algorithm_name,
       :date => real_quote["trade_date"],
       :real_quote => Quote.from_openstruct(real_quote).to_hash,
       :forecasted_quote => Quote.from_openstruct(forecasted_quote).to_hash,
       :difference => difference.to_hash
      }
      return accuracy_row
    end
    nil
  end
  
  

end



ac = Accucheck.get_instance
ac.run
ac.accuracy_global

