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

    1.times.each do |i|

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

            myd = {:symbol => f[:symbol],
                 :current => JSON.parse(::Forecasting::Quote.from_openstruct(last_quote).to_j),
                 :diff => difference,
                 :max_threshold => JSON.parse((max_quote_in_history-min_quote_in_history).to_j),
                 :max=>JSON.parse(max_quote_in_history.to_j),
                 :min=>JSON.parse(min_quote_in_history.to_j),
                 :time_between_min_max=> (Date.strptime(max_quote_in_history.trade_date,"%Y-%m-%d") - Date.strptime(min_quote_in_history.trade_date,"%Y-%m-%d")).to_i.to_s 
                }
            
            if (differences.select{ |e| e.hash==myd.hash  }.size==0) and (myd[:time_between_min_max].to_i>0)
              differences.push(myd)
            end
            
            
          end

        else
          puts "There is an error calculating the difference for symbol: " + f[:symbol]
 
        end

    
      end 
      
    end

    output = File.open( "report-mins-" + Date.today.to_s + ".json" ,"w" )
    
    puts "Writing file...."
    
    # sort by least difference with current quote
    # sort by the max amount earned between min and max values
    # sort by the shortest time first
    
    
    
    output << differences.sort_by{|d| ::Forecasting::Quote.from_openstruct(d[:diff]) }.
                          sort_by{|d|  ::Forecasting::Quote.from_openstruct(d[:max_threshold])}.
                          reverse.sort_by{|d| d[:time_between_min_max].to_i.abs.to_s }.
                          to_json
    
    output.close
    
    puts "File written !!"
  end
  
  
  
  private
  


  
  def get_last_quote(symbol)
    lastq = @service.last_quote(symbol)
    
    
  end
  
end



end
