module InvestorHelper
  
  class Investor

    def initialize
      begin
        # connect to the MySQL server
        @dbh = Mysql.real_connect("localhost", "root", "justice", "crawler")
        # get server version string and display it
        puts "Server version: " + @dbh.get_server_info
      rescue Mysql::Error => e
        puts "Error code: #{e.errno}"
        puts "Error message: #{e.error}"
        puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
      end       
    end



    #High risk investment is 1

    # Amount to invest in dollars
    # days you plan to invest your money
    # Risk quoficient for the operation
    # channel where to sell products
    # Check for products sold abroad and not in country.
    def generate_investment_plan(amount,days,riskq,channel,sold_abroad)

  
      earn_a_day = amount.to_f / days.to_f
  
      # This query does not accept a product that has not been sold for a day at least once 
      res = @dbh.query "select products.id,products.title,products.link,products.localcost
                        from products,
                        (select product,min(amount)
                         from sales 
                         group by product 
                         having (min(amount)>0) ) as grouped_sales 
                         where (localcost <= " + earn_a_day.to_s + ") and (products.id = grouped_sales.product) and (channel='" + channel + "') order by localcost desc;"
      return res
    end


end

  
  
  
end
