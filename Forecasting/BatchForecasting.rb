load 'Chunk.rb'
load 'Company.rb'
load 'Point.rb'
load 'Quote.rb'
load 'DrawSelector.rb'
require 'Forecaster'
require 'AvgForecaster'
require 'DeltaForecaster'
load 'files/symbols.rb'



include Forecasting




class BatchForecasting
  


    
  @symbols
  @algorithms
  
  
  
  def initialize(symbols)
    @symbols = symbols
    
    avgf = Forecasting::Forecaster::AvgForecaster.new
    deltaf = Forecasting::Forecaster::DeltaForecaster.new
    
    @algorithms = [avgf,deltaf]
    
    
  end
  
  
  
  def run(amount_of_days)
    
    
    @symbols.each do |s|
      
      company = Forecasting::Company.new(s)
      
      @algorithms.each do |a|
        puts a.forecast_on_me(company,amount_of_days).to_j   # Here should be the mongo insert        
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

