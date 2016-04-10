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

    page_size = 20

    pages = (count/page_size).round

    pages.times.each do |i|

      puts "Processing page " + i.to_s + " of " + pages.to_s
 
      @db[:Forecasts].find({}).skip(i*page_size).limit(page_size).to_a.each do |f|
    
        history = ::Forecasting::Chunk.new(f[:history])
 
        min_quote_in_history = history.min_historic_value
        max_quote_in_history = history.max_historic_value
        
        #puts "The min quote for " + f[:symbol] + " is " + min_quote_in_history.inspect
      
        last_quote = get_last_quote(f[:symbol])
        #puts "The last quote for " + f[:symbol] + " is " + last_quote.inspect
        
        if (!min_quote_in_history.nil? and !last_quote.nil? and !max_quote_in_history.nil?)

          difference = JSON.parse((min_quote_in_history - ::Forecasting::Quote::from_openstruct(last_quote)).to_j)

          if !difference.nil?          

            differences.push({:symbol => f[:symbol],:current => JSON.parse(::Forecasting::Quote.from_openstruct(last_quote).to_j),:diff => difference,:max_threshold => (max_quote_in_history-min_quote_in_history)})

          end

        else
          puts "There is an error calculating the difference for symbol: " + f[:symbol]
 
        end

    
      end 
      
    end

    output = File.open( "report-mins-" + Date.today.to_s + ".json" ,"w" )
    
    output << differences.sort_by{|d| d[:diff] }.reverse.sort_by{|d| d[:max_threshold]}.reverse.to_json
    
    output.close
    
    
  end
  
  
  
  private
  


  
  def get_last_quote(symbol)
    lastq = @service.last_quote(symbol)
    
    
  end
  
end



end
