require 'yahoo-finance'
require 'json'
require 'date'
load 'Forecaster.rb'
load 'AvgForecaster.rb'
load 'DeltaForecaster.rb'
load 'Quote.rb'


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
    @yahoo_client = YahooFinance::Client.new
    @symbol = symbol
    @history = nil
    @splits = nil
  end
  
  
  
  
  def get_previous_quote
    begin
      last_five_quotes = @yahoo_client.historical_quotes(@symbol,{start_date: Time.now-(24*60*60*5), end_date: Time::now })
      previous_quote = Quote.from_openstruct(last_five_quotes[-2])
      previous_quote                      
    rescue
      puts "Error retrieving previous quote for symbol " + @symbol
      nil
      
    end
  end
  
  

  def all_history
    if @history.nil?
      begin
        @history = @yahoo_client.historical_quotes(@symbol)        
        #puts "HISTORY: " + Chunk.new(@history).to_j
      rescue OpenURI::HTTPError => e
      
        #puts e.message
        
      end  
        
    end
    if !@history.nil?
      @history.map{|q| 
        Quote.new(q['trade_date'],q['open'],q['close'],q['high'],q['low'],q['volume'],q['adjusted_close'],q['symbol'])
      } 
      if !self.get_last_split_date.nil?
        @history = @history.select{|q|      
          Date.strptime(q.trade_date,"%Y-%m-%d") >= self.get_last_split_date}
      end
      
      Chunk.new(@history)
    end
    
  end
  
  
  def get_split_dates
    if @splits==nil
      @splits = @yahoo_client.splits(@symbol, :start_date => Date.today - 20*365)
    end
    @splits
  end
  
  def get_last_split_date
    if !@splits.nil?
      self.get_split_dates[0]['date']
    else
      nil  
    end
  end
  



  def all_history_between(period)
    begin
      data = @yahoo_client.historical_quotes(@symbol,period)
      data_chunk = Chunk.new(data)
      #puts "YAHOO " + data_chunk.inspect
      
      data_chunk
    rescue
      #puts "FAILED TO GET HISTORY FOR COMPANY " + @symbol
      
    end
  end

  def current_quote_realtime
    data = @yahoo_client.quote(@symbol, [:ask_real_time])
    data.ask_real_time.to_s    
  end

  def last_quote
    begin      
      l = self.all_history_between({ start_date: Time::now-(24*60*60*2), end_date: Time::now }).first
    #puts "LASTQUOTE " + l.inspect
#    Quote.new(l['trade_date'],l['open'],l['close'],l['high'],l['low'],l['volume'],l['adjusted_close'],l['symbol'])
      Quote.from_openstruct(l)
    rescue
      #puts "FAILED TO GET LAST QUOTE FOR COMPANY: " + @symbol
    end
  end
  
  
  
  def forecast(forecaster,amount_of_days)
    forecaster.forecast_on_me(self,amount_of_days)    
  end




end


end
