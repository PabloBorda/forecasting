require 'rubygems'
require 'mongo'
require 'bson'
require 'net/ssh/gateway'
require 'aspector'

require_relative 'YahooFinanceAPI.rb'
require_relative '../aspects/TimingAspect.rb'
require_relative '../services/MongoConnector.rb'

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
          insertion_counter = 0
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
            
              if insertion_counter==0
                @db[:Quotes].insert_one(q)
                insertion_counter = insertion_counter + 1
              else
                insertion_counter = 0
              end                
            else
              puts "Connection to yahoo finance failed for symbol: " + s
            end
          else
            # Get only the missing quotes from the last_update on and append them to the history array and save
            quote_to_update = existing_symbol.to_a[0]
            b = quote_to_update[:history].last[:trade_date]
            #puts "TRADE DATE" + b.inspect
            days_ago = ((Time.now - Time.strptime(b.to_s,'%Y-%m-%d'))/(24*60*60)).to_i 
            missing_history = @source.all_history_between(s,{ start_date: Time::now-(24*60*60*days_ago), end_date: Time::now })
            #puts "MISSING HISTORY " + missing_history.inspect
            if !missing_history.nil?  
              quote_to_update[:history] = (missing_history.to_hashes.uniq + existing_symbol.to_a[0][:history].uniq).uniq.sort {|a,b|  Time.parse(b[:trade_date]) <=> Time.parse(a[:trade_date]) }
              quote_to_update[:last_update] = Time::now
              puts "UPDATING " + s + "..."
              @db[:Quotes].update_one({:symbol => s},quote_to_update)
              puts "UPDATEd......"
            else
              puts "No missing history for symbol: " + s
            end 
          end
        end
        

      end

      private

      def initialize
        
        
        #TimingAspect.apply(YahooFinanceAPI)
        #TimingAspect.apply(Mongo::Client)
        TimingAspect.apply(QuoteCrawler)
        @source = YahooFinanceAPI.get_instance()
        @symbols = @source.get_all_us_symbols()

        connector = ::Services::MongoConnector.get_instance
        @db  = connector.connect
                                 

      end
      
      

    end

  end

end
