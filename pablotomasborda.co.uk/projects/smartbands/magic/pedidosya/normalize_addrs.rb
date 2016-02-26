# encoding: ISO-8859-1
require 'rubygems' 
require 'hpricot'
require 'open-uri'
require 'mechanize'
require 'logger'
require 'mysql'
require 'i18n' 
load 'database_mapping.rb'






@cities = [{"Argentina" => ["Febrero","Adrogue","Avellaneda","Berazategui","Capital","Federal","Cordoba","Don","Torcuato","Esteban","Echeverria","General","Rodriguez","Gregorio","Lafer","Hurlingham","Ituzaingo","Jose","Carlos","Paz","Jose","Leon","Suarez","La","Matanza","La","Plata","Lanus","Lomas","Zamora","Mar","Plata","Martinez","Mercedes","Merlo","Moreno","Morón","Pilar","Quilmes","Rosario","San","Martin","San","Miguel","Tigre","Turdera","Vicente","Lopez","Wilde","Buenos","Aires"]},  
          {"Colombia" => ["Armenia","Barranquilla","Bogota","Bucaramanga","Cajica","Cali","Cartagena","Chia","Cucuta","Girardot","Ibague","Manizales","Medellin","Neiva","Pasto","Pereira","Popayan","Santa Marta","Sogamoso","Tunja","Villavicencio","Yopal","Zipaquira"]},
          {"Peru" => ["Ancon","Asia","Ate","Barranco","Bellavista","Brena","Callao","Carabayllo","Carmen","Legua","Reynoso","Chaclacayo","Chorrillos","Cieneguilla","Comas","El","Agustino","Grumete","Medina","Independencia","Jesus","Molina","Perla","Punta","Victoria","Virreinas","Lima","Lince","Olivos","Lurigancho","Chosica","Lurin","Magdalena","Miraflores","Pachacamac","Pucusana","Pueblo","Libre","Puente","Piedra","Punta","Hermosa","Punta","Negra","Reynoso","Rimac","Salamanca","San","Bartolo","San","Borja","San","Isidro","Lurigancho","Miraflores","Luis","Porres","Miguel","Anita","Maria","Mar","Rosa","Santiago","Surco","Surquillo","Ventanilla","Salvador","Villa","Triunfo"]},
          {"Brazil" => ["Barueri","Belo","Horizonte","Brasilia","Campinas","Carapicuiba","Contagem","Cotia","Curitiba","Diadema","Embu","Ferraz","Vasconc","Franco","Rocha","Guarulhos","Ibirite","Itu","Jandira","Jundiai","Mairipora","Maua","Mogi","Cruzes","Osasco","Poa","Porto","Alegre","Salvador","Parnaiba","Andre","Bernardo","Caetano","Boa","Campos","Paulo","Serra"]},
          {"Chile" => ["Araucania","Atacama","Biobio","Concepcion","Rios","Magallanes","Rancagua","RM","Tarapaca","Valparaiso"]},
          {"Uruguay" => ["Costa","Maldonado","Montevideo","Paysandu","Piriapolis","Este"] }
]





def filter_accent(s)
  if !s.nil?
    return I18n.transliterate(s) 
  else
    return ""
  end

end






def get_country_from_address(addr)

  addr.id

end




def one_of_previous_cities?(addr,country)


  if (((@cities.select {|k| k[country]}[0][country].collect {|c| (c).downcase! }) & (addr.split(" ").collect { |k| filter_accent((k).downcase!)}) ).size > 0)
   # puts "The address " + addr + " is the desired one"
    return true
  else
    return false
  end

end







def normalize(addr)
 if (addr[:address].size > 6) 
    country = guess_country(addr)
    filtered_string = (addr[:address] + " " + country.to_s)
    url = "http://maps.google.com/maps/api/geocode/json?address="
    par = filtered_string + "&sensor=false" 
    uri = (URI.parse ("#{url}#{URI::encode(par)}")) #puts "URL is: " + url
    puts "VISIT: " + uri.to_s
 
    @res = JSON.parse(Net::HTTP.get_response(uri).body.to_s)
    count = 0 
 #   while ((@res.to_s.include? "ZERO_RESULTS") or (@res.to_s.include? "OVER")) and (count <= 10) do 
    #  puts "TRY AGAIN: " + @res.to_s 
      #puts @res.to_s sleep(2) # prox = get_random_proxy() # puts prox.to_s # http = Net::HTTP::Proxy(prox[:ip].to_s,prox[:port].to_i,nil,nil) 
 #     @res = JSON.parse(Net::HTTP.get_response(uri).body.to_s)
 #     count = count + 1 
 #     sleep(5)
 #   end 
 #   if (count > 10)
  #    sleep(10000)
 #   end

    #puts @res
    if (@res!=nil) and (!@res.to_s.include? "ZERO_RESULTS") and (!@res.to_s.include? "OVER")
      lat = @res["results"][0]["geometry"]["location"]["lat"].to_s
      lng = @res["results"][0]["geometry"]["location"]["lng"].to_s
      puts "LAT: " + lat 
      puts "LNG: " + lng 
      addr.lat = (lat.to_f) 
      addr.lng = (lng.to_f) 
      addr.address = @res["results"][0]["formatted_address"]
      if (!addr.address.nil?) and (!country.nil?)
        if one_of_previous_cities?(addr.address,country)
          puts "ADDRESS IS SAVED" 
        else
          puts addr.address + " seems not to be from one of the defined cities"
        end
      end
      addr.save
    else
      puts "Error on getting address data"
    end
  end

end



def guess_country(a)
  extension = {"ar" => "Argentina", "br" => "Brazil", "co" => "Colombia", "pe" => "Peru","cl" => "Chile", "uy" => "Uruguay"}
  s = (Store.find_by_address_id(a.id.to_s))
  if !s.nil?
   c = extension[(Company.find_by_id(s.company_id)).webpage.to_s[-2..-1]]
  end
 #puts " The country for address " + a.address.to_s + " is " + c.to_s
  c
end



addrs = Address.find(:all,:conditions => "(lat=0) and (lng=0) and (address not like '%Local%') and (address not like '%Calle%') and (address not like '%Carrera%') and (address not like '%hopping%')")
#addrs = Address.find(:all,:conditions => "(lat=0) and (lng=0) and (address like '%Cabello%')")




addrs.each { |a|
   
  normalize(a)
  sleep(1)
}
