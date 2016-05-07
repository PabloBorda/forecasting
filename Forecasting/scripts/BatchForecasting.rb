require_relative '../model/Chunk.rb'
require_relative '../model/Company.rb'
require_relative '../model/Point.rb'
require_relative '../model/Quote.rb'
require_relative '../algorithms/selectors/DrawSelector.rb'
require_relative '../algorithms/Forecaster.rb'
require_relative '../algorithms/AvgForecaster.rb'
require_relative '../algorithms/DeltaForecaster.rb'
require_relative '../Files/symbols.rb'
require 'date'
require 'json'
require 'rubygems'
require 'mongo'



include Forecasting




class BatchForecasting
  

  
    
  @symbols
  @algorithms
  @db
  @collection 
  
  include Mongo
  
  def initialize(symbols)
    @symbols = symbols
    
    avgf = Forecasting::Forecaster::AvgForecaster.new
    deltaf = Forecasting::Forecaster::DeltaForecaster.new
    
    @algorithms = [avgf,deltaf]
    
    @db  = Mongo::Client.new([ 'localhost:27017' ], :database => 'alphabrokers') 
 
   
  end
  
  
  
  def run(amount_of_days)
    puts "DIR: " + Dir.pwd
    @last_symbol = File.open("../Files/last_symbol.rb","rb").read

    puts "LAST SYMBOL: " + @last_symbol
    
    if !@last_symbol.include? "nil"
      index = @symbols.find_index(@last_symbol) + 1
    else
      index = 0
    end

    puts "THE INDEX IS: " + index.to_s    
    count_insert = 1
   
    total_symbols = -1
    symbols_size = @symbols[index..-1].size
    @symbols[index..-1].each do |s|
      total_symbols = total_symbols + 1
      puts "PROGRESS, SYMBOL: " + s + " NUMBER: " +  total_symbols.to_s + " OF " + symbols_size.to_s
    
      company = Forecasting::Company.new(s)
      company_history = company.all_history
      
      if !company_history.nil?
      
      
        output_to_insert_to_mongo = { :symbol => s ,              # we dont know company name
                                      :company_name => s,
                                      :forecasts => [],
                                      :date => Time.now } 
      
        @algorithms.each do |a|
          forecast = a.forecast_on_me(company,amount_of_days)
          if !forecast.nil?
            algorithm = {:algorithm_name => a.class.to_s.split("::").last,
                         :date => Date.today.to_s,
                         :accuracy => 0,
                         :amount_of_days => amount_of_days.to_s,
                         :forecast => JSON.parse(forecast.to_j),
                         :real_values => [],
                         :custom => ""
                     
            }
        
          
            output_to_insert_to_mongo[:forecasts].push algorithm      
          end
                             
          ##puts output_to_insert_to_mongo.to_json
        end
        
        if count_insert==1
          @db[:Forecasts].insert_one(output_to_insert_to_mongo)  # Here should be the mongo insert
          count_insert = count_insert - 1
        end  
         
        
        output_to_insert_to_mongo = nil
        
      end
      
      company = nil
      company_history = nil
      File.open("../Files/last_symbol.rb", 'w') {|f| f.write(s) }
      count_insert = 1  
      
    end
    
    
  end
  
  
  def stop
  end
  
  
  def pause
  end
  
  
  
  
end





bf = BatchForecasting.new(@symbols)

bf.run(60)

