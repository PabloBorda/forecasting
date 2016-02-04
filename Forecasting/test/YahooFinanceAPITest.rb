require 'test/unit'
require 'test/unit/ui/console/testrunner'
require_relative "../services/YahooFinanceAPI.rb"
require_relative "../model/Quote.rb"




class YahooFinanceAPITest < Test::Unit::TestCase
  
  include Forecasting
  
  
  def setup
    @yahoo = YahooFinanceAPI.new
  end
  
  
  def teardown
  end
  
  
  def test_get_symbols
        
    assert(@yahoo.get_all_us_symbols().size > 0,"symbols are fine") 
    
  end
  
  
  def test_all_history
    history = @yahoo.all_history("AAPL")    
    assert((history.size > 0),("There are " + history.size.to_s + " elements.")) 
  end
  
  
  def test_get_split_dates
    splits = @yahoo.get_split_dates("AAPL")
    assert(splits.size>0,"Splits are " + splits.inspect)        
  end

  def test_get_last_split_date
    assert(!@yahoo.get_last_split_date("AAPL").nil?,"There should be only one")
    
  end
  
  
  def test_all_history_between
    quotes = @yahoo.all_history_between("AAPL",{ start_date: Time::now-(24*60*60*240), end_date: Time::now }) 
    puts "quotes: " + quotes.size.to_s
    assert(quotes.size>0,"Many quotes were returned")

    
    
  end
  
  
  
  
  
  
    
end






Test::Unit::UI::Console::TestRunner.run(YahooFinanceAPITest)