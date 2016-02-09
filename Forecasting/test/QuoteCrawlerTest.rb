require 'test/unit'
require 'test/unit/ui/console/testrunner'

require_relative '../services/QuoteCrawler.rb'




class QuoteCrawlerTest < Test::Unit::TestCase
  
  include Forecasting::QuoteData
  
  
  def setup
    @crawler = QuoteCrawler.get_instance
  end
  
  
  def teardown
  end
  
  
  def test_crawl
    @crawler.crawl
    assert(true,"test crawl")
  end
  
    
end






Test::Unit::UI::Console::TestRunner.run(QuoteCrawlerTest)