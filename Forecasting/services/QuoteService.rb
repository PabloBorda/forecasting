
require 'json'
require 'date'
require_relative '../services/YahooFinanceAPI.rb'
require_relative '../algorithms/Forecaster.rb'
require_relative '../algorithms/AvgForecaster.rb'
require_relative '../algorithms/DeltaForecaster.rb'
require_relative 'MongoFinanceAPI.rb'
require_relative 'Quote.rb'



module Forecasting
  module Services
   
    
    
    
    class QuoteService

      @service
      @sources
      def get_instance
        if @service.nil?
          @service = QuoteService.new
        end
        @sources.push(MongoFinanceAPI.get_instance)
        @sources.push(YahooFinanceAPI.get_instance)
        
        
        @service
      end

      
  
      def get_previous_quote
        
        @yahoo_client.get_previous_quote(@symbol)
      end
  
      def all_history
        @yahoo_client.all_history(@symbol)
      end
  
      def get_split_dates
        @yahoo_client.get_split_dates(@symbol)
      end
  
      def get_last_split_date
        @yahoo_client.get_last_split_date(@symbol)
      end
  
      def all_history_between(period)
        @yahoo_client.all_history_between(@symbol,period)    
      end
  
      def current_quote_realtime
        @yahoo_client.current_quote_realtime(@symbol)           
      end
  
      def last_quote
        @yahoo_client.last_quote(@symbol)
      end
      
      
      
      
      
      
      private

      def initialize
      end

    end

 
  
  
  
  
  
  
  
  
  
  end

end