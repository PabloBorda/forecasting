
require 'yahoo-finance'

class YahooFinanceAPI
  
  @yahoo_client
  
  def initialize
    @yahoo_client = YahooFinance::Client.new
  end
  
  def get_all_us_symbols
    @yahoo_client.symbols_by_market('us', 'nasdaq')
    
  end
  
  
  
end