require 'test/unit'
require 'test/unit/ui/console/testrunner'
require_relative "../services/MongoFinanceAPI.rb"
require_relative "../model/Quote.rb"




class MongoFinanceAPITest < Test::Unit::TestCase
  
  include Forecasting
  
  
  def setup
    @mongo_service = MongoFinanceAPI.get_instance
  end
  
  
  def teardown
  end
  
  
  def test_get_symbols
        
    assert(@mongo_service.get_all_us_symbols().size > 0,"symbols are fine") 
    
  end
  
  
  def test_all_history
    history = @mongo_service.all_history("AAPL")    
    assert((history.size > 0),("There are " + history.size.to_s + " elements."))
  end
  
  
  def test_get_split_dates
    splits = @mongo_service.get_split_dates("AAPL")
    assert(splits.size>0,"Splits are " + splits.inspect)        
  end

  def test_get_last_split_date
    assert(!@mongo_service.get_last_split_date("AAPL").nil?,"There should be only one")
    
  end
  
  
  def test_all_history_between
    quotes = @mongo_service.all_history_between("AAPL",{ start_date: Time::now-(24*60*60*240), end_date: Time::now }) 
    puts "quotes: " + quotes.size.to_s
    assert(quotes.size>0,"Many quotes were returned")

    
    
  end
  
  def test_get_all_us_symbols
    symbols = @mongo_service.get_all_us_symbols()
    puts symbols.size.to_s + " symbols were returned"
    assert(symbols.size>0,"Make sure there are many symbols")
  end
  
  def test_last_quote
    quote = @mongo_service.last_quote("AAPL")
    puts "LAST QUOTE" + quote.inspect
    assert((!quote.nil? and quote.close>0),"The last quote is erroneus")
  end
  
  
  def test_get_quote_for_date
    my_quote = @mongo_service.get_quote_for_symbol_date("AAPL",Time.strptime("2016-03-10",'%Y-%m-%d'))
    puts "quote for date is " + my_quote.inspect
    assert(!my_quote.nil?,"Wrong quote")
  end
  
  
  
  
    
end






Test::Unit::UI::Console::TestRunner.run(MongoFinanceAPITest)