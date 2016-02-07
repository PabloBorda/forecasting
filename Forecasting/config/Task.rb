require 'logger'
require 'json'

class Task
  def self.trading_starts
    trading_start = {:type => "trading_start"}
    @logger.info(trading_start.to_json) 
  end
  
  def self.trading_stops
    trading_finishes = {:type => "trading_finishes"}
    @logger.info(trading_finishes)
  end
  
end