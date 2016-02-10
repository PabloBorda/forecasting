require 'rubygems'
require 'mongo'
require 'bson'
require 'net/ssh/gateway'

require_relative 'YahooFinanceAPI.rb'

module  Forecasting
  module QuoteData
    class QuoteCrawler

      @source
      @service
      @symbols
      def self.get_instance
        if @service.nil?
          @service = QuoteCrawler.new
        end
        @service
      end

      def crawl
        @symbols.each do |s|
          existing_symbol = @db[:Quotes].find({:symbol => s}) 
          if (existing_symbol.to_a.size==0)
            history = @source.all_history(s)
            history_j = ""
            if !history.nil?
              history_j = history.to_j

              q = {

                :symbol => s,
                :last_update => Date.today,
                :history => JSON.parse(history_j)

              }
            
            
              @db[:Quotes].insert_one(q)                
            end
          else
            # Get only the missing quotes from the last_update on and append them to the history array and save
            b = existing_symbol.to_a[0][:last_update]
            days_ago = ((Time.now - b)/(24*60*60)).to_i 
            missing_history = @source.all_history_between(s,{ start_date: Time::now-(24*60*60*days_ago), end_date: Time::now })
            existing_symbol.to_a[0][:history] = existing_symbol.to_a[0][:history] + missing_history.to_hashes
            puts "UPDATING " + s + "..."
            @db[:Quotes].update_one({:symbol => s},existing_symbol.to_a[0]) 
          end
        end

      end

      private

      def initialize
        @source = YahooFinanceAPI.get_instance()
        @symbols = @source.get_all_us_symbols()

        @gateway = Net::SSH::Gateway.new('178.62.123.38', 'root', :password => 'alphabrokers')
        @gateway.open('178.62.123.38', 27017, 27018)

        @db  = Mongo::Client.new([ 'localhost:27018' ], :database => 'alphabrokers')

      end
      
      

    end

  end

end