require 'yahoo-finance'
require 'json'


module Forecasting


  
  

  
class Chunk

  @chunk_data
  @selector
  def initialize(chunk)
    @chunk_data = chunk
    @selector = DrawSelector.new(@chunk_data)
  end
  

  def to_html
    
    (@chunk_data.inject("<table border=\"1\"><tr><td>SYMBOL</td><td>TRADE_DATE</td><td>OPEN</td><td>CLOSE</td><td>HIGH</td><td>LOW</td><td>VOLUME</td</td><td>ADJUSTED_CLOSE</td>") {|o,q|
       o = o + Quote.from_openstruct(q).to_row
    }) + "</table>"
  
  end
  

  def self.to_html(chunk)
    Chunk.new(chunk).to_html
  end


  def to_deltas
    delta = []
    @chunk_data.each_with_index { |q,i| 
      if (i==0)
        delta.push(q)        
      else
        delta.push(q - Quote.from_openstruct(@chunk_data[i-1]))
      end
    }    
    delta  
  end
  
  
  
  def similar_points_not_stepping_on_each_other(last_quote,amount_of_days)
    #Sort quotes by similarity with current quote, and then sort by date descendant

    similar_quotations = @selector.draw_horizontal_line(last_quote)
    
    similar_quotations_reverse = similar_quotations.reverse
    similar_quotations_reverse_first_element_removed = similar_quotations_reverse[1..-1]
    similar_quotations = similar_quotations_reverse_first_element_removed[0..amount_of_days].map {|q| Quote.from_openstruct(q) }
      
    puts "SIMILAR QUOTATIONS ARE " + similar_quotations.to_json  
    similar_points_stepping_on_each_other = []
   

    point_count = 0
    while (point_count<(similar_quotations.size)) do
      current_quote = similar_quotations[point_count]
      #puts "CURRENT DATA: " + @chunk_data.class.to_s  
      current_quote_position_in_all_quotes = @chunk_data.find_index {|q| Quote.from_openstruct(q).compare(current_quote) }
      previous_chunk_from_current_quote = @chunk_data[current_quote_position_in_all_quotes-amount_of_days..current_quote_position_in_all_quotes-1]
    #puts "previous_chunk_from_current_quote: " + previous_chunk_from_current_quote.inspect
      next_chunk_from_current_quote = @chunk_data[current_quote_position_in_all_quotes+1..current_quote_position_in_all_quotes+amount_of_days]
      puts "next_chunk_from_current_quote: " + next_chunk_from_current_quote.inspect
      similar_points_stepping_on_each_other.push(Point.new(current_quote,previous_chunk_from_current_quote,next_chunk_from_current_quote))
    
      point_count = point_count + 1

    end
   # puts "POINTS STEPING ON EACH OTHER" + similar_points_stepping_on_each_other.inspect
   
    similar_points_not_stepping_on_each_other_var = []
  
  similar_points_stepping_on_each_other.each_with_index.map {|p,i|
      count = i+1     
      while (!similar_points_stepping_on_each_other[count].nil?) do 
         p1 = similar_points_stepping_on_each_other[count]     
         p.remove_repeated_prev_and_next_chunk_from_point(p1)
     similar_points_not_stepping_on_each_other_var.push(p)
         count = count + 1
      end

    }

    puts "POINTS NOT STEPING ON EACH OTHER" + similar_points_not_stepping_on_each_other_var.inspect
    similar_points_not_stepping_on_each_other_var



  end



  def last
    @chunk_data.last
  end

  def find_quote(q)
    #puts "IM A TYPE: " + q.class.to_s
    @chunk_data.find_index {|h| Quote.from_openstruct(h).compare(q)}
  end

  def size
    @chunk_data.size
  end

  def data
    @chunk_data
  end
end

end