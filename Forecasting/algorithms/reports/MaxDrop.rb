require_relative "../../services/QuoteService.rb"
require_relative "../../model/Quote.rb"
require_relative '../../services/MongoConnector.rb'
require_relative '../reports/Reporter.rb'

require 'rubygems'
require 'mongo'
require 'date'


module Reports


class MaxDrop < Reporter
  
  
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
    
    visited_symbol = []

    pages.times.each do |i|

      puts "Processing page " + i.to_s + " of " + pages.to_s
 
      @db[:Forecasts].find({}).skip(i*page_size).limit(page_size).to_a.each do |f|
        if !f[:history].nil?
          
          if !visited_symbol.include?(f[:symbol])
          
            visited_symbol.push(f[:symbol])
            history = ::Forecasting::Chunk.new(f[:history])
     
            history.maxdrop()
              
              
              
          end
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
