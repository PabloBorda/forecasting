require_relative "../services/QuoteService.rb"
require_relative "../model/Quote.rb"


module Reports


class MinHistoricCurrentQuoteDifferenceReport < Reporter
  
  
  @service
  def initialize
    @service = ::Forecasting::Services::QuoteService.get_instance 
  end
  
  
  
  
  
  
end



  end