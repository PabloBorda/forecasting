require 'singleton'
require 'unirest'
require 'json'
require_relative '../model/Quote.rb'

class GoldRealTime
  
  include Singleton
  
  
  #  curl "http://www.24hgold.com/english/gold_silver_prices_charts.aspx/GetLastValue?sCurrency=USD" -H "Content-Type: application/json; charset=utf-8"
  def real_time_quote
    response = Unirest.get("http://www.24hgold.com/english/gold_silver_prices_charts.aspx/GetLastValue?sCurrency=USD", 
                            headers: { "Content-Type" => "application/json" }, 
                            parameters: { :age => 23, :foo => "bar" })
    
    response.code # Status code
    response.headers # Response headers
    response.body # Parsed body
    response.raw_body # Unparsed body
    gold_silver_price = JSON.parse(response.raw_body)
    #puts "from service: " + gold_silver_price.to_s
    gold_price = gold_silver_price["d"][1][0] + gold_silver_price["d"][1][2..7].gsub(",",".") 
    silver_price = gold_silver_price["d"][6].gsub(/\s+/,"").gsub(",",".")
    puts gold_price
    #puts silver_price
    [::Forecasting::Quote::from_symbol_and_price("GOLD",gold_price),::Forecasting::Quote::from_symbol_and_price("SILVER",silver_price)]
  end

end




class NeuralNetwork
  
  
  attr_accessor :drop
  
  def initialize
    @values = []
    self.drop = 0
  end
  
  def teach_you(current_price)
    value = current_price.close
    #puts "values:" + @values.inspect
    #puts "JU:" + value.inspect
    if (@values[@values.size-1].to_f<value.to_f)
      self.drop = self.drop - 1
    else
      if (@values[@values.size-1].to_f > value.to_f)
        self.drop = self.drop + 1
      else
        self.drop = 0
      end    
    end
    
    @values.push value
     
  end
  
  
end





#  ["43 778,39","1 361,66","43,78","#00FF00","-0,18%","639,80","19,90","0,64","#00FF00","-0,95%","39 505,62","1 228,76","39,51","#00FF00","-0,06%","577,36","17,96","0,58","#00FF00","-0,82%"]



#{"d":["43 832,72","1 363,35","43,83","#FF0000","-0,06%","641,09","19,94","0,64","#FF0000","-0,75%","39 563,41","1 230,56","39,56","#FF0000","0,09%","578,64","18,00","0,58","#FF0000","-0,60%"]}


gold_service = GoldRealTime.instance
gold_neural_network = NeuralNetwork.new
while (1==1)
  
  current_prices = gold_service.real_time_quote
  
  gold_neural_network.teach_you(current_prices[0])
  #puts "drop: " + gold_neural_network.drop.to_s
  if (gold_neural_network.drop < -3)
    puts "DROPPING!!!"
  else
    if (gold_neural_network.drop == 0)
      puts "IS QUIET"
    else
      if (gold_neural_network.drop > 3)
        puts "RISING!!!"
      end
    end
  end
  sleep(2)
  
end

