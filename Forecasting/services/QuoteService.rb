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

      def get_previous_quote
        source_num = 0
        previous_quote = @@sources[source_num].get_previous_quote
        while previous_quote.nil?
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_previous_quote
        end

      end

      def all_history(symbol)
        source_num = 0
        puts "CLASS IS" + @@sources.class.to_s
        previous_quote = @@sources[source_num].all_history(symbol)
        while previous_quote.nil?
          source_num = source_num + 1
          previous_quote = @@sources[source_num].all_history(symbol)
        end

      end

      def get_split_dates(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].get_split_dates(symbol)
        while previous_quote.nil?
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_split_dates(symbol)
        end
      end

      def get_last_split_date(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].get_last_split_date(symbol)
        while previous_quote.nil?
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_last_split_date(symbol)
        end
      end

      def all_history_between(period)
        source_num = 0
        previous_quote = @@sources[source_num].all_history_between(period)
        while previous_quote.nil?
          source_num = source_num + 1
          previous_quote = @@sources[source_num].all_history_between(period)
        end
      end

      def current_quote_realtime(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].current_quote_realtime(symbol)
        while previous_quote.nil?
          source_num = source_num + 1
          previous_quote = @@sources[source_num].current_quote_realtime(symbol)
        end
      end

      def last_quote(symbol)
        source_num = 0
        previous_quote = @@sources[source_num].last_quote(symbol)
        while previous_quote.nil?
          source_num = source_num + 1
          previous_quote = @@sources[source_num].last_quote(symbol)
        end
      end

      def get_all_us_symbols
        source_num = 0
        previous_quote = @@sources[source_num].get_all_us_symbols
        while previous_quote.nil?
          source_num = source_num + 1
          previous_quote = @@sources[source_num].get_all_us_symbols
        end

      end

      private

      def initialize

      end

    end

  end

end