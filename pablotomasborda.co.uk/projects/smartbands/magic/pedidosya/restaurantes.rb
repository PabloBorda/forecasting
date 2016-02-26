	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'mechanize'
	require 'logger'
	require 'mysql'
	require 'i18n'
        require 'set'
	load 'database_mapping.rb'


	   class String
	  
		 def filter_shit
		  return ((!include? "Ã¡") and
				  (!include? "Ã©") and
				  (!include? "Ã­") and
				  (!include? "Ã³") and
				  (!include? "Ãº") and
				  (!include? "Ã¼") and
				  (!include? "@") and
				  (!include? "!") and
				  (include? "mercado") and
				  (!include? "...") and
				  (!include? "mailto"))
		  
		end

		
		
		
		
		
	   end





	class CrawlPedidosYa

	  

	  @agent
	  @avoid
	  def initialize
		Mechanize::Util::CODE_DIC[:SJIS] = "ISO-8859-1"
		@agent = Mechanize.new { |a| a.log = Logger.new("mech.log")
		}
		@agent.user_agent_alias = "Mac Safari"
		@proxies = []
		@avoid = Set.new []
	  end



	  def get_random_proxy()
		f = File.open("proxy.txt","r") do |f1|  
		  while line = f1.gets  
			@ipport = line.split(":")
			@proxies.push({:ip => @ipport[0], :port => @ipport[1]})
		  end
		end
		count = 0
		value = `ping #{@proxies[count].to_s}`
		while (!value.include? "0% packet loss") do
		  value = `ping #{@proxies[count][:ip].to_s}`
		  count = count + 1
		end
		return @proxies[count] 
	  end





	  def filter_accent(s)
		return I18n.transliterate(s)
		
	  end
	  
	  
	  
	   
	  def get_addr_data(addr_string)
		addr = Address.new
		filtered_string = filter_accent(addr_string)
		puts "The address is: " + filtered_string
		url = ("http://maps.google.com/maps/api/geocode/json?address=" + filtered_string + "&sensor=false")
		uri = (URI.parse (URI.encode(url.strip)))
		#puts "URL is: " + url
		

	   # prox = get_random_proxy()
	   # puts prox.to_s
	  #  http = Net::HTTP::Proxy(prox[:ip].to_s,prox[:port].to_i,nil,nil) 
	 
	 
		@res = JSON.parse(Net::HTTP.get_response(uri).body.to_s)

		if (addr_string.size > 6)
		  count = 0 
		  while ((@res.to_s.include? "ZERO_RESULTS") or (@res.to_s.include? "OVER")) and (count <= 10) do
			puts "get addr try again\n"
			#puts @res.to_s
			sleep(2)
		   # prox = get_random_proxy()
		   # puts prox.to_s
		   # http = Net::HTTP::Proxy(prox[:ip].to_s,prox[:port].to_i,nil,nil) 
			@res = JSON.parse(Net::HTTP.get_response(uri).body.to_s)
			count = count + 1
		  end
		  if (count > 10)
			return nil
		  end
		  #puts @res.to_s
		  lat = @res["results"][0]["geometry"]["location"]["lat"].to_s
		  lng = @res["results"][0]["geometry"]["location"]["lng"].to_s
		  puts "LAT: " + lat
		  puts "LNG: " + lng
	 addr = Address.find_or_create_by_address(@res["results"][0]["formatted_address"]) {
		  |a|
		  a.lat = (lat.to_f)
		  a.lng = (lng.to_f)
		  a.address =  @res["results"][0]["formatted_address"]
	  }
		  addr
		end
	  end
	 

	   

     def filter_url(url)
       (!(url.include? "comentario") and !(url.include? "mobile") and !(url.to_s.include? "javascript") and ((url.include? "restaurant") or (url.include? "restaurantes") or (url.eql? "http://www.pedidosya.com.ar")) and (!@avoid.include? url.to_s) )

     end




     def get_context(url)

       if (!Visit.find_by_link(url.to_s + "/info"))
         context = Context.new
		 
         response = @agent.get(url.to_s + "/info")
	 Visit.create({:link => url.to_s + "/info"})	 
         surface = response.parser.xpath("//*[contains(@id, 'ctl00_ctl00_ContentMain_ContentRestaurant_hidDeliveryZone')]/@value")
         timesheet = response.parser.xpath("//*[contains(@class, 'time-right')]/text()")
         
		 
		 context.zone = surface.to_s
		 context.mon = timesheet[0].to_s
         context.tue = timesheet[1].to_s
		 context.wed = timesheet[2].to_s
		 context.thu = timesheet[3].to_s
		 context.fri = timesheet[4].to_s
		 context.sat = timesheet[5].to_s
		 context.sun = timesheet[6].to_s
		 
		 minorder_price = response.parser.xpath("//*[contains(@id, 'ctl00_ctl00_ContentMain_lblMinAmountValue')]/text()")
		 context.minorder = minorder_price.to_s
		 
         estimated_time = response.parser.xpath("//*[contains(@id, 'ctl00_ctl00_ContentMain_lblDeliveryTimeValue')]/text()")
         context.estimated = estimated_time.to_s
		 context.save
		 context
       else
         nil
       end
		 
     end



     def crawl(url,level)
       #puts "AVOID " + @avoid.to_s
       if filter_url(url) 
       # if (level <= 100)
           if ((url.include? "restaurantes") or (url.eql? "http://www.pedidosya.com.ar"))
             puts "Visiting: " + url.to_s + " Level: " + level.to_s	
	     @page = @agent.get url
             @avoid.add url.to_s
	     lnks = @page.links
	     #puts "LINKS ARE: " + lnks.to_s
             lnks.each do |l|
               if (!Visit.find_by_link(url))
                 if (l.href.to_s.include? "http://www.pedidosya.com.ar")
                   crawl(l.href.to_s,(level+1))
                 else
                   crawl("http://www.pedidosya.com.ar" + l.href.to_s,(level+1))
                  end
               end
             end
	     @avoid.add ("http://www.pedidosya.com.ar" + url.to_s)
             Visit.find_by_sql("select * from visits where link like \'%" + url.to_s + "%\';") || Visit.create({:link => url.to_s})
	   else
             puts "Checking if a restaurant"
             if (url.include? "restaurant") and (!@avoid.include? url.to_s)
               puts "New restaurant: " + url.to_s
               ctx = self.get_context(url.to_s)
               @page = @agent.get url
               @avoid.add url.to_s
	       #myaddr = get_addr_data(@page.parser.xpath("//*[@id=\"ctl00_ctl00_ContentMain_lblAddress\"]").inner_html.to_s)                
               #if !(myaddr.nil?)
	         @products = []
		 cname = @page.parser.xpath("//*[@id=\"ctl00_ctl00_ContentMain_lblRestaurantName\"]").inner_html.to_s  # get company name
		 puts "Company name: " + cname
		 if !(Company.find_by_name(cname))
    	          # myaddr = Address.new
				 
	          # myaddr.address = @page.parser.xpath("//*[@id=\"ctl00_ctl00_ContentMain_lblAddress\"]").inner_html.to_s
	          # myaddr.lat = "0"
	          # myaddr.lng = "0"
	          # myaddr.save
	
		   clogo = @page.parser.xpath("//*[@id=\"ctl00_ctl00_ContentMain_imgRestaurant\"]/@src").inner_html.to_s  # get company logo
		   download_img = `cd logos && mkdir #{cname.delete(" ").to_s } && cd #{cname.delete(" ").to_s} && wget #{clogo}`
		   puts "Download logo " + clogo
		   puts "Company logo: " + clogo
		   comp = Company.create {
		     |c|
		     c.name = cname
		     c.logo = "/logos/" + cname.delete(" ").to_s + "/" + clogo.split("/").last.to_s
		     c.webpage = "http://www." + c.name.to_s.delete(" ") + ".com.ar"
		     c.account = Account.create(:account_type_id => 3,:user => c.name,:password => c.name,:email => "info@" + c.name.delete(" ").to_s + ".com")
		     c.email = "info@" + c.name.delete(" ").to_s + ".com"
		     c.enabled = true
  		   } 
		   account_store = Account.create(:account_type_id => 3,:user => comp.name,:password => comp.name,:email => comp.name.delete(" ").to_s + "@chat.smartbands.com.ar")

		   store = Store.new
		   store.company = comp
		   addre = Address.new
		   addre.address = @page.parser.xpath("//*[@id=\"ctl00_ctl00_ContentMain_lblAddress\"]").inner_html.to_s 
		   addre.lat = "0"
		   addre.lng = "0" 
		   #addre = get_addr_data(@page.parser.xpath("//*[@id=\"ctl00_ctl00_ContentMain_lblAddress\"]").inner_html.to_s)   # get store address including lat and lng from google map api
		   if !(addre.nil?)
		     addre.save
		     store.address = addre
		     store.context = ctx
			 store.account = account_store
		     store.open = true
		     store.save
		     puts "failed to get url"
		   end
	           puts "Parsing categories"
		   categories = @page.parser.xpath("//*[@class=\"title-2\"]/text()")
		   categories.each do |c|
		     sup = Superproduct.create {|s|
		       s.name = c.to_s
		     }
		     curr = Category.create {|ca|
		       ca.name = c.to_s
		       ca.purchase_count = 0 
		     }
		     products = @page.parser.xpath("//*[@class=\"menu-cat\"]/div[starts-with(@id,\"divSection\")]/div[@sectionparent=\"" + c.to_s + "\"]/div[@class=\"name\"]/a/text()")
		     count = 0
		     products.each do |p|					  
		       prod = Product.create {|pr|
		         pr.name = p.to_s
		         pr.price = @page.parser.xpath("//*[@class=\"menu-cat\"]/div[starts-with(@id,\"divSection\")]/div[@sectionparent=\"" + c.to_s + "\"]/div[@class=\"price\"]/text()")[count].to_s.to_f
		         pr.company_id = comp.id
		         pr.category_id = curr.id
		         pr.superproduct_id = sup.id
		         pr.description = curr.name + " " + p.to_s
		         pr.orders = 0
		         pr.running = true
		         count = count + 1 
		       }
		     end
		     puts c.inner_html.to_s
                   end
                 end
               #end
               @avoid.add url.to_s
               Visit.find_by_link(url.to_s) || Visit.create({:link => url.to_s})
             end
           end  
        # end
       end
     end
	
end

     @crawler = CrawlPedidosYa.new
     @crawler.crawl("http://www.pedidosya.com.ar",0)

#     Visit.find_by_sql("select * from visits where link like \'%http://www.pedidosya.com.ar/restaurantes%\' order by id desc;").each do |last|
#      puts "STARTING FROM " + last[:link].to_s + " ==============================================="
#      if (last[:link].to_s.include? "http://www.pedidosya.com.ar")
#        @crawler.crawl(last[:link].to_s,0)
#      else
#       @crawler.crawl("http://www.pedidosya.com.ar" + last[:link].to_s,0)
#      end
#    end
#@crawler = CrawlPedidosYa.new
#@crawler.crawl("http://www.pedidosya.com.ar",0)

