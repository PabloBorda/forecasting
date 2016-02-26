
class DashboardController < ActionController::Base
  
  
  def welcome
    
  end


  def show_most_sold_yesterday
    @most_sold_yesterday = (DashboardHelper::MostSoldProducts.new).most_sold
    
  end

  def calculate_suggestions
    
    
  end
  
  def show_investment_form
    
    
  end
  
  def show_questions
    
  end
  
  def order_log
    
  end
  
end