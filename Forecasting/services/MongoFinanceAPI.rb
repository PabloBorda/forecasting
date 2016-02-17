require_relative '../model/Quote.rb'
require_relative '../model/Chunk.rb'
require_relative '../Files/symbols.rb'
require_relative 'YahooFinanceAPI.rb'
require_relative '../services/MongoConnector.rb'


require 'date'
require 'json'
require 'rubygems'
require 'mongo'
require 'bson'
require 'net/ssh/gateway'
require 'logger'

class MongoFinanceAPI

  include Forecasting

  @mongo_client
  @singleton
  @splits
  def self.get_instance
    if @singleton.nil?
      @singleton = MongoFinanceAPI.new
    end
    @singleton
  end

  def get_all_us_symbols
    YahooFinanceAPI.get_instance.get_all_us_symbols
  end

  def all_history(symbol)
    Chunk.new(@mongo_client[:Quotes].find({:symbol => symbol}).to_a[0][:history].map do |qhash|
                Quote.from_ruby_hash(JSON.parse(qhash.to_json))
      
              end)    
  end

  def get_split_dates(symbol)
    YahooFinanceAPI.get_instance.get_split_dates(symbol)
  end

  def get_last_split_date(symbol)
    YahooFinanceAPI.get_instance.get_last_split_date(symbol)
  end

  def all_history_between(symbol,period)
    @mongo_client[:Quotes].find({:symbol => symbol}).to_a[0][:history].select do |q|
      trade_date = Date.strptime(q[:trade_date],"%Y-%m-%d") 
      (trade_date >= period[:start_date].to_date) && (trade_date <= period[:end_date].to_date)
    end    
  end

  def current_quote_realtime(symbol)
    YahooFinanceAPI.get_instance.current_quote_realtime(symbol)
  end

  def last_quote(symbol)
    puts "LAST QUOTE IS: " + @mongo_client[:Quotes].find({:symbol => symbol}).inspect
    Quote.from_ruby_hash(@mongo_client[:Quotes].find({:symbol => symbol})[:history].last)
  end

  def get_previous_quote(symbol)
    @mongo_client[:Quotes].find({:symbol => symbol})[:history][-2]
  end

  private

  def initialize

    connector = ::Services::MongoConnector.get_instance
    @mongo_client  = connector.connect

    

  end

end