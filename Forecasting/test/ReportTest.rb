require 'test/unit'
require 'test/unit/ui/console/testrunner'

require_relative "../algorithms/reports/MinHistoricCurrentQuoteDifferenceReport.rb"




class ReportTest < Test::Unit::TestCase
  
  include Reports
  
  
  def setup
    @reporter = MinHistoricCurrentQuoteDifferenceReport.new
  end
  
  
  def teardown
  end
  
  
  def test_run
        
    @reporter.run
    
  end
  
    
  
  
      
end






Test::Unit::UI::Console::TestRunner.run(ReportTest)