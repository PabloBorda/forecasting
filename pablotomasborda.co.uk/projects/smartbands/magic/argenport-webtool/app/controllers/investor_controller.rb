class InvestorController < ApplicationController
  
  def invest_my_money
    i = InvestorHelper::Investor.new
    amount_to_invest = params['amount-to-invest']
    days_to_invest = Integer(params['time-to-invest'])
    riskq = Integer(params['risk-level'])
    channel= "MLAR"
    sold_abroad = false
    
    @res = i.generate_investment_plan(amount_to_invest,days_to_invest,riskq,channel,sold_abroad)
    
  end
  
  
  
  
  
  
  
end
