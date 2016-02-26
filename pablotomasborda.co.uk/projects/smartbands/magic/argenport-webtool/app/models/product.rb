class Product < ActiveRecord::Base
  has_many :sales
  
  
  
  def maxsoldday
    Product.find_by_sql("select * from products,sales where sales.product=" + self.id.to_s + " order by sales.amount desc limit 10;")
  end
  
  
  def leastsoldday
    
  end
  
end
