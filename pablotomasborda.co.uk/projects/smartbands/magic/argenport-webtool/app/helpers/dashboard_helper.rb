require 'rubygems'
require 'mechanize'
require 'hpricot'
require 'config/argenport_cfg.rb'

module DashboardHelper
	
	class MostSoldProducts
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
	  
	  def most_sold
	    
	    return @dbh.query("select products.localcost,products.title,products.link,products.sold,max(sales.amount),min(sales.amount)
                         from products,sales
                         where (sales.product = products.id)
                         group by sales.product limit 10;")
	  end
	  
	end
	
	
	
	class WebSiteHandler
	  
	 
	  
	  def initialize(user,pass)
	    @logged = false
	    @user = user
	    @pass = pass
	    @browser = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }
      
	  end
	  
	  @questions_answers = []
	    
	  def retrieve_questions_to_answer
	    
	  end
	  
	  def logger?
	    @logged
	  end
	  
	  
	
	
	protected
	  
	  def login

	  end
	  
	  
	  
	end
	
	class MercadoLibreSiteHandler < DashboardHelper::WebSiteHandler
	  
	  
	  
	  
	  def get_questions
	    if @logged 
	      
	      questions_div = @browser.get("http://questions.mercadolibre.com.ar/seller")
	      questioned_products = questions_div.parser.xpath('/html/body/div[2]/div[2]/ol/li/div/div/dl/dd[class="itemInfo"]')
	      questions_for_each_product = questions_div.parser.xpath('/html/body/div[2]/div[2]/ol/li/div/div[2]/ol[class="questions"]')
	      count = 0
	      questioned_products.each { 
	        |p|
	        @questions_answers.push [p.text,@questions_for_each_product.text]
	      }
	      
	      
	      
	      @questions_div.parser.xpath("/html/body/div[2]/div[2]/ol/li/div/div[2]/ol")
	    end
	    
	  end
	  
	  protected
	    def login
	      login_frm = @browser.get("http://www.mercadolibre.com/jms/mla/secureLogin").form('form_main')
        login_frm.user = @user
        login_frm.password = @password
        @to_questions = @browser.submit(login_form, login_form.buttons.first)
        @logged = true
	    end
	  
	  
	  
	end
	
	
	
	

end