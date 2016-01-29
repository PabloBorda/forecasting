
require 'yahoo-finance'

class YahooFinanceAPI
  
  @yahoo_client
  @singleton
  
  def initialize
    if @singleton.nil?     
      @yahoo_client = YahooFinance::Client.new
      @singleton = self  
    end
    
  end
  
  def get_all_us_symbols
    @yahoo_client.symbols_by_market('us', 'nasdaq')
    
  end
  
  
  
end