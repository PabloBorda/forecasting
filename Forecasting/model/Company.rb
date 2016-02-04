
require 'json'
require 'date'
require_relative '../services/YahooFinanceAPI.rb'
require_relative '../algorithms/Forecaster.rb'
require_relative '../algorithms/AvgForecaster.rb'
require_relative '../algorithms/DeltaForecaster.rb'
require_relative 'Quote.rb'

class Object
  def unless_nil(default = nil, &block)
    nil? ? default : block[self]
  end
end

module Forecasting
  class Company

    @symbol
    @yahoo_client
    @history
    @splits
    def initialize(symbol)
      @yahoo_client = YahooFinanceAPI.getInstance
      @symbol = symbol
      @history = nil
      @splits = nil
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

    def forecast(forecaster,amount_of_days)
      forecaster.forecast_on_me(self,amount_of_days)
    end

  end

end
