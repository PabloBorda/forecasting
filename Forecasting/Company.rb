require 'yahoo-finance'
require 'json'
require 'Forecaster'
require 'AvgForecaster'
require 'DeltaForecaster'


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

  def initialize(symbol)
    @yahoo_client = YahooFinance::Client.new
    @symbol = symbol
    @history = nil
  end

  def all_history
    if @history.nil?
      @history = @yahoo_client.historical_quotes(@symbol)
    end
    @history.map{|q| 
      Quote.new(q['trade_date'],q['open'],q['close'],q['high'],q['low'],q['volume'],q['adjusted_close'],q['symbol'])
    } 
    Chunk.new(@history)
  end



  def all_history_between(period)
      data = @yahoo_client.historical_quotes(@symbol,period)
      
      puts "YAHOO " + data.inspect
      Chunk.new(data)
  end

  def current_quote_realtime
    data = @yahoo_client.quote(@symbol, [:ask_real_time])
    data.ask_real_time.to_s    
  end

  def last_quote
    l = self.all_history_between({ start_date: Time::now-(24*60*60*7), end_date: Time::now }).first
    #puts "LASTQUOTE " + l.inspect
#    Quote.new(l['trade_date'],l['open'],l['close'],l['high'],l['low'],l['volume'],l['adjusted_close'],l['symbol'])
    Quote.from_openstruct(l)
  end
  
  
  
  def forecast(forecaster,amount_of_days)
    forecaster.forecast_on_me(self,amount_of_days)    
  end




end


end