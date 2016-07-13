require 'singleton'
require 'json'
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





class Node
  
  attr_accessor :quote
  attr_accessor :left_node
  attr_accessor :right_node
  
  def initialize(quote)
    self.quote = quote 
    self.left_node = nil
    self.right_node = nil  
  end
 
  
  def <=> (n)
    ((self.quote) < (n.quote))
    
  end

  
   
  def insert_quote(quote)    
    if (self.quote.nil?)
      self.quote = quote
    else       
      if (quote < self.quote)
        if self.left_node.nil?
          self.left_node = Node.new(quote)
        else
          self.left_node.insert_quote(quote)
        end
      else
        if (quote > self.quote)
          if (self.right_node.nil?)
            self.right_node = Node.new(quote)
          else
            if (quote > self.quote)
              self.right_node.insert_quote(quote)
            end
          end
        end
      end        
    end
  end
    
  def print_tree
    lo = ""
    qo = ""
    ro = ""
    if self.left_node.nil? 
      lo = "nil"
    else
      lo = self.left_node.print_tree
    end


    if self.right_node.nil?
      ro = "nil"
    else
      ro = self.right_node.print_tree
    end

        
    if self.quote.nil?
      qo = "nil"
    else
      qo = self.quote.close.to_s
    end
    
    puts "qo" + qo.inspect
    puts "lo" + lo.inspect
    puts "ro" + ro.inspect
    
    simple_chart_config = {
       
     
      
        :text => {:name => qo },
        :children => [
          {
            :text => {:name => lo} 
          },
          {
            :text => {:name => ro }
          }
          
          
         ]
      }
      
      
      
    
    
    simple_chart_config
    #"[" + lo + "]----" + "{" + qo + "}" + "----[" + ro + "]"
     
    
  end
  
  
  
end




class BTree
  
  
  attr_accessor :drop
  attr_accessor :tree
  @last_quote
  
  def initialize     
    self.drop = 0
  end
  
  def teach_you(current_price)
    if (!@last_quote.nil?)
      value = current_price.close      
      #puts "values:" + @values.inspect
      #puts "JU:" + value.inspect
    
      if (@last_quote.close.to_f<value.to_f)
        self.drop = self.drop - 1
      else
        if (@last_quote.close.to_f > value.to_f)
          self.drop = self.drop + 1
        else
          self.drop = 0
        end    
      end
    end
    @last_quote = current_price 
    self.insert_quote(current_price)
    
  end
  
  
  def insert_quote(quote)
    if self.tree.nil?
      self.tree = Node.new(quote)
    else
      self.tree.insert_quote(quote)
    end
  end
  
  
  def print_tree
    if self.tree.nil?
      puts "nil"
    else
      puts ({:chart => { :container => "#OrganiseChart-simple" },:nodeStructure => self.tree.print_tree }.to_json)
    end
  end
  
  
  
end


gold_service = GoldRealTime.instance
btree_quotes = BTree.new
rise_count = 0
drop_count = 0
quiet_count = 0

while (1==1)
  
  current_prices = gold_service.real_time_quote
  
  btree_quotes.teach_you(current_prices[0])
  #puts "drop: " + btree_quotes.drop.to_s
  if (btree_quotes.drop < -3)
    
    drop_count = drop_count + 1
    puts "DROPPING!!!: " + drop_count.to_s
  else
    if (btree_quotes.drop == 0)      
      quiet_count = quiet_count + 1
      puts "quiet: " + quiet_count.to_s
    else
      if (btree_quotes.drop > 3)        
        rise_count = rise_count + 1
        puts "RISING!!!: " + rise_count.to_s 
      end
    end
  end
  puts btree_quotes.print_tree
  sleep(2)
  
end

