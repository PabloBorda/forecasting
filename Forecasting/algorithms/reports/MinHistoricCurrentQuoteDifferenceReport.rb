require_relative "../../services/QuoteService.rb"
require_relative "../../model/Quote.rb"
require_relative '../../services/MongoConnector.rb'
require_relative '../reports/Reporter.rb'

require 'rubygems'
require 'mongo'
require 'date'


module Reports


class MinHistoricCurrentQuoteDifferenceReport < Reporter
  
  
  @service
  def initialize
    @service = ::Forecasting::Services::QuoteService.get_instance 
    connector = ::Services::MongoConnector.get_instance    
    @db  = connector.connect
    
  end
  
  
  def run
    
    
    differences = []
 
    count = @db[:Forecasts].count()

    pages = (count/10).round

    page_size = 50

    pages.times.each do |i|
 
    
  
      @db[:Forecasts].find({}).skip(i*page_size).limit(page_size).to_a.each do |f|
     
        min_quote_in_history = min_historic_value(f[:history])
        #puts "The min quote for " + f[:symbol] + " is " + min_quote_in_history.inspect
      
        last_quote = get_last_quote(f[:symbol])
        #puts "The last quote for " + f[:symbol] + " is " + last_quote.inspect
        
        difference = ::Forecasting::Quote.from_openstruct(min_quote_in_history) - ::Forecasting::Quote.from_openstruct(last_quote)

        differences.push(difference)

    
      end 
      
    end

    output = File.open( "report-mins-" + Date.today.to_s + ".json" ,"w" )
    
    output << differences.sort.to_json
    
    output.close
    
    
  end
  
  
  
  private
  
  def min_historic_value(history)
    history.min do |p,q|
      p[:close] <=> q[:close]
    end    
  end
  
  def get_last_quote(symbol)
    lastq = @service.last_quote(symbol)
    
    
  end
  
end



end