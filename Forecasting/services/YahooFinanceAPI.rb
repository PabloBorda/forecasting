require 'yahoo-finance'
require_relative '../model/Quote.rb'
require_relative '../model/Chunk.rb'


class YahooFinanceAPI

  
  include Forecasting
  
  
  
  @yahoo_client
  @singleton
  @splits
  
  def self.get_instance
    if @singleton.nil?
      @singleton = YahooFinanceAPI.new
    end
    @singleton
  end

  def get_all_us_symbols
    @yahoo_client.symbols_by_market('us', 'nasdaq')
  end
  
  
  
  def all_history(symbol)
       begin
         @history = @yahoo_client.historical_quotes(symbol)
         #puts "HISTORY: " + Chunk.new(@history).to_j              
         @history.map{|q|
           Quote.new(q['trade_date'],q['open'],q['close'],q['high'],q['low'],q['volume'],q['adjusted_close'],q['symbol'])
         }
         if !self.get_last_split_date(symbol).nil?
           @history = @history.select{|q|
             Date.strptime(q.trade_date,"%Y-%m-%d") >= self.get_last_split_date(symbol)}
         end
 
         Chunk.new(@history)
       rescue
         puts "Error retrieving " + symbol
       end
 
  end
  
  
  
     
     
  def get_split_dates(symbol)
    if @splits==nil
      @splits = @yahoo_client.splits(symbol, :start_date => Date.today - 20*365)
    end
    @splits
  end

  def get_last_split_date(symbol)
    if @splits.nil?
      @splits = self.get_split_dates(symbol)      
    end
    if @splits.size>0
      @splits[0]['date']
    else
      nil 
    end
  end
  
  
  
  def all_history_between(symbol,period)
     begin
       data = @yahoo_client.historical_quotes(symbol,period)
       data_chunk = Chunk.new(data)
       #puts "YAHOO " + data_chunk.inspect

       data_chunk
     rescue
       #puts "FAILED TO GET HISTORY FOR COMPANY " + @symbol

     end
 end

 def current_quote_realtime
   data = @yahoo_client.quote(symbol, [:ask_real_time])
   data.ask_real_time.to_s
 end

 def last_quote(symbol)
   begin
     l = self.all_history_between(symbol,{ start_date: Time::now-(24*60*60*2), end_date: Time::now }).first
     #puts "LASTQUOTE " + l.inspect
     #    Quote.new(l['trade_date'],l['open'],l['close'],l['high'],l['low'],l['volume'],l['adjusted_close'],l['symbol'])
     Quote.from_openstruct(l)
   rescue
     #puts "FAILED TO GET LAST QUOTE FOR COMPANY: " + @symbol
   end
 end
  
  
 def get_previous_quote(symbol)
   puts "SYMBOL: " + symbol.to_s
   last_five_quotes = @yahoo_client.historical_quotes(symbol,{start_date: Time.now-(24*60*60*5), end_date: Time::now })
   puts "LAST FIVE" + last_five_quotes.inspect
   previous_quote = Quote.from_openstruct(last_five_quotes[-2])
   previous_quote   
 end  
 
 
 
 
  
  private
  
  def initialize
    @yahoo_client = YahooFinance::Client.new

  end
  
     
     
     

end