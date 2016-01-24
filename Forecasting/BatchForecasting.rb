load 'Chunk.rb'
load 'Company.rb'
load 'Point.rb'
load 'Quote.rb'
load 'DrawSelector.rb'
load 'Forecaster.rb'
load 'AvgForecaster.rb'
load 'DeltaForecaster.rb'
load 'files/symbols.rb'
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
    
    @db = Mongo::Client.new([ 'localhost:27017' ], :database => 'alphabrokers') 
 
 
   
  end
  
  
  
  def run(amount_of_days)
    
    
    @symbols.each do |s|
      
      company = Forecasting::Company.new(s)
      company_history = company.all_history
      
      if !company_history.nil?
      
      
        output_to_insert_to_mongo = { :symbol => s ,              # we dont know company name
                                    :company_name => s,
                                    :forecasts => [] ,
                                    :history =>  JSON.parse(company_history.to_j)} 
      
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
          @db[:Forecasts].insert_one(output_to_insert_to_mongo)  # Here should be the mongo insert  
        end
        
      
      end
    end
    
  end
  
  
  def stop
  end
  
  
  def pause
  end
  
  
  
  
end







bf = BatchForecasting.new(@symbols)

bf.run(60)

