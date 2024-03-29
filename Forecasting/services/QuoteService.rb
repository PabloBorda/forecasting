require 'json'
require 'date'

require_relative '../services/YahooFinanceAPI.rb'
require_relative '../algorithms/Forecaster.rb'
require_relative '../algorithms/AvgForecaster.rb'
require_relative '../algorithms/DeltaForecaster.rb'
require_relative 'MongoFinanceAPI.rb'
require_relative '../model/Quote.rb'

module Forecasting
  module Services
    class QuoteService

      @service
      @@sources
      def self.get_instance
        if @service.nil?
          @@sources = []
          @@sources.push(MongoFinanceAPI.get_instance)
          @@sources.push(YahooFinanceAPI.get_instance)
          @service = QuoteService.new
        end
        @service
      end

      def get_previous_quote(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].get_previous_quote(symbol)
        while (previous_quote.nil? or previous_quote.is_neutral?)  
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_previous_quote(symbol)
        end
        previous_quote
      end

      def all_history(symbol)
        source_num = 0
        puts "CLASS IS" + @@sources.class.to_s
        until (@@sources[source_num].nil?)  
          previous_quote = @@sources[source_num].all_history(symbol)
          source_num = source_num + 1
        end
        previous_quote

      end

      def get_split_dates(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].get_split_dates(symbol)
        while (previous_quote.nil?)  
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_split_dates(symbol)
        end
        previous_quote
      end

      def get_last_split_date(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].get_last_split_date(symbol)
        while (previous_quote.nil?)  
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_last_split_date(symbol)
        end
        previous_quote
      end

      def all_history_between(symbol,period)
        source_num = 0
        previous_quote = @@sources[source_num].all_history_between(symbol,period)
        while previous_quote.size==0
          source_num = source_num + 1
          previous_quote = @@sources[source_num].all_history_between(symbol,period)
        end
        previous_quote
      end

      def current_quote_realtime(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].current_quote_realtime(symbol)
        while (previous_quote.nil? or previous_quote.is_neutral?)  
          source_num = source_num + 1
          previous_quote = @@sources[source_num].current_quote_realtime(symbol)
        end
        previous_quote
      end

      def last_quote(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].last_quote(symbol)
        puts "PREVIOUSQUOTE: " + previous_quote.inspect
        while (previous_quote.nil? or previous_quote.is_neutral?) and (source_num < @@sources.size)         
          source_num = source_num + 1
          puts "LASTUPDATE " + @@sources[source_num].inspect
          if !@@sources[source_num].nil?
            previous_quote = @@sources[source_num].last_quote(symbol)
            puts "PREVIOUSQUOTE " + previous_quote.inspect
          end
        end
        previous_quote
      end

      def get_all_us_symbols
        source_num = 0
        previous_quote = @@sources[source_num].get_all_us_symbols
        while (previous_quote.nil?)  
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_all_us_symbols
        end
        previous_quote

      end
      
      
      
      def get_quote_for_symbol_date(symbol,at)
        
        source_num = 0
        previous_quote = @@sources[source_num].get_quote_for_symbol_date(symbol,at)
        while (previous_quote.nil?)  
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_quote_for_symbol_date(symbol,at)
        end
        previous_quote
      end

      private

      def initialize

      end

    end

  end

end
