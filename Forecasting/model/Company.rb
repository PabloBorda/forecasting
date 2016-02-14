
require 'json'
require 'date'
require_relative '../services/QuoteService.rb'
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
    @source
    @history
    @splits
    def initialize(symbol)
      @source = QuoteService.getInstance
      @symbol = symbol
      @history = nil
      @splits = nil
    end

    def get_previous_quote
      @source.get_previous_quote(@symbol)
    end

    def all_history
      @source.all_history(@symbol)
    end

    def get_split_dates
      @source.get_split_dates(@symbol)
    end

    def get_last_split_date
      @source.get_last_split_date(@symbol)
    end

    def all_history_between(period)
      @source.all_history_between(@symbol,period)    
    end

    def current_quote_realtime
      @source.current_quote_realtime(@symbol)           
    end

    def last_quote
      @source.last_quote(@symbol)
    end

    def forecast(forecaster,amount_of_days)
      forecaster.forecast_on_me(self,amount_of_days)
    end

  end

end
