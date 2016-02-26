require "xmpp4r/client"
include Jabber

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
  
  def purify_address(addr)
    addr = addr.gsub("Diagonal","Diag")
    addr = addr.gsub("Avenida","Av")
    addr = addr.gsub("diagonal","diag")
    addr = addr.gsub("avenida","Av")
  end


	



   def quita_acentos( cadena )

     cadena = cadena.gsub("á", "a")
     cadena = cadena.gsub("é", "e")
     cadena = cadena.gsub("í", "i")
     cadena = cadena.gsub("ó", "o")
     cadena = cadena.gsub("ú", "u")
     cadena = cadena.gsub("ñ", "n")
     cadena = cadena.gsub("�","en")
     cadena = cadena.gsub("Ã³","o")
     cadena = cadena.gsub(" ", "%20")
     

    end
	
	
	class JabberAdviser
	
		def initialize(jid,passwd)
			@jid = JID::new(jid)
			@passwd = passwd
			@cl = Client::new(jid)
            @cl.connect
            @cl.auth(passwd)
		end
		
		def advise(store_addr,message)
			@to = store_addr
			@subject = "New deliver request!"
			m = Message::new(@to, message).set_type(:normal).set_id('1').set_subject(@subject)
			@cl.send m
		end
		
		
	end
	
	
	class ClosestStoreLocator
		
		def initialize
			
		end
		
		def find_closest_store(lat,lng,company)
			 @sql = "SELECT delivery.stores.id, ( 3959 * acos( cos( radians(" + lat.to_s + ") ) * cos( radians( lat ) ) * cos( radians( lng ) - radians(" + lng.to_s + ") ) + sin( radians(" + lat.to_s + ") ) * sin( radians( lat ) ) ) ) AS distance FROM (delivery.stores inner join delivery.addresses on delivery.stores.addresses_id = delivery.addresses.id) where companies_id = " + company.to_s + " HAVING distance < 25 ORDER BY distance LIMIT 0 , 20;"
			 puts "=================" + @sql
			 @t=(ActiveRecord::Base.connection.execute(@sql))
			 @t.fetch_row[0].to_s
			
		end
		
		
	end
	
	
	
end
