require_relative '../model/Quote.rb'
require_relative '../model/Chunk.rb'
require_relative '../Files/symbols.rb'

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
    @symbols
  end

  def all_history(symbol)
    @mongo_client[:Quotes].find({:symbol => symbol})    
  end

  def get_split_dates(symbol)
    nil
  end

  def get_last_split_date(symbol)
    nil
  end

  def all_history_between(symbol,period)
    @mongo_client[:Quotes].find({:symbol => symbol})[:history].select do |q|
      trade_date = Date.strptime(q[:trade_date],"%Y-%m-%d") 
      (trade_date >= period[:start_date]) && (trade_date <= period[:end_date])
    end    
  end

  def current_quote_realtime
    nil
  end

  def last_quote(symbol)
    nil
  end

  def get_previous_quote(symbol)
    nil
  end

  private

  def initialize
    @gateway = Net::SSH::Gateway.new('178.62.123.38', 'root', :password => 'alphabrokers')
    @gateway.open('178.62.123.38', 27017, 27018)

    @mongo_client  = Mongo::Client.new([ 'localhost:27018' ], :database => 'alphabrokers')

    

  end

end