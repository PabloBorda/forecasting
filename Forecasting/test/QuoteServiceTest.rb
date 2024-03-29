require 'test/unit'
require 'test/unit/ui/console/testrunner'
require_relative "../services/QuoteService.rb"
require_relative "../model/Quote.rb"




class QuoteServiceTest < Test::Unit::TestCase
  
  
  
  
  def setup
    @quote_service = Forecasting::Services::QuoteService.get_instance
  end
  
  
  def teardown
  end
  
  
  def test_get_symbols
        
    assert(@quote_service.get_all_us_symbols().size > 0,"symbols are fine") 
    
  end
  
  
  def test_all_history
    history = @quote_service.all_history("AAPL")    
    assert((history.size > 0),("There are " + history.size.to_s + " elements.")) 
  end
  
  
  def test_get_split_dates
    splits = @quote_service.get_split_dates("AAPL")
    assert(splits.size>0,"Splits are " + splits.inspect)        
  end

  def test_get_last_split_date
    assert(!@quote_service.get_last_split_date("AAPL").nil?,"There should be only one")
    
  end
  
  
  def test_all_history_between
    quotes = @quote_service.all_history_between("AAPL",{ start_date: Time::now-(24*60*60*5), end_date: Time::now }) 
    puts "quotes: " + quotes.size.to_s
    puts "all_history_between" + quotes.to_j
    assert(quotes.size>0,"Many quotes were returned")

    
    
  end
  
  def test_get_all_us_symbols
    symbols = @quote_service.get_all_us_symbols()
    puts symbols.size.to_s + " symbols were returned"
    assert(symbols.size>0,"Make sure there are many symbols")
  end
  
  def test_last_quote
    last_quote = @quote_service.last_quote("AAPL")
    puts "LAST_QUOTE " + last_quote.inspect
    assert((!last_quote.nil? and last_quote.close!=0),"last quote error")
    
  end
  
  
  
  def test_get_quote_for_date
    my_quote = @quote_service.get_quote_for_symbol_date("AAPL",Time.strptime("2016-03-10",'%Y-%m-%d'))
    puts "quote for date is " + my_quote.inspect
    assert(!my_quote.nil?,"Wrong quote")
  end
  
  
    
end






Test::Unit::UI::Console::TestRunner.run(QuoteServiceTest)