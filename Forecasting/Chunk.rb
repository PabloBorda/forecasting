require 'yahoo-finance'
require 'json'


module Forecasting


  
  

  
class Chunk

  @chunk_data
  
  @selector
  def initialize(chunk)
    if (chunk.class.to_s.include? "Chunk")
      puts "YOU INSERTING A CHUNK!"
    end
    @chunk_data = chunk.compact
    @selector = DrawSelector.new(self)
  end
  

  def to_html
    
    (@chunk_data.compact.inject("<table border=\"1\"><tr><td>SYMBOL</td><td>TRADE_DATE</td><td>OPEN</td><td>CLOSE</td><td>HIGH</td><td>LOW</td><td>VOLUME</td</td><td>ADJUSTED_CLOSE</td>") {|o,q|       
       puts "Q: " + q.inspect   
       if (q.class.to_s.include? "Chunk")
         puts "YOU INSERTING A CHUNK!"
       end      
       o = o + Quote.from_openstruct(q).to_row.to_s             
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
      
   # puts "SIMILAR QUOTATIONS ARE " + similar_quotations.to_json  
    similar_points_stepping_on_each_other = []
   

    point_count = 0
    while (point_count<(similar_quotations.size)) do
      current_quote = similar_quotations[point_count]      
      current_quote_position_in_all_quotes = @chunk_data.find_index {|q| Quote.from_openstruct(q).compare(current_quote) }
      previous_chunk_from_current_quote = @chunk_data[current_quote_position_in_all_quotes-amount_of_days..current_quote_position_in_all_quotes-1]    
      next_chunk_from_current_quote = @chunk_data[current_quote_position_in_all_quotes+1..current_quote_position_in_all_quotes+amount_of_days]
    #  puts "next_chunk_from_current_quote: " + next_chunk_from_current_quote.inspect
      similar_points_stepping_on_each_other.push(Point.new(current_quote,previous_chunk_from_current_quote,next_chunk_from_current_quote))    
      point_count = point_count + 1

    end
   
   
    similar_points_not_stepping_on_each_other_var = []
  
  similar_points_stepping_on_each_other.each_with_index.map {|p,i|
      count = i+1     
      if (!similar_points_stepping_on_each_other[count].nil?) 
         p1 = similar_points_stepping_on_each_other[count]     
         p.remove_repeated_prev_and_next_chunk_from_point(p1)
         similar_points_not_stepping_on_each_other_var.push(p)
      end

    }

 #   puts "POINTS NOT STEPING ON EACH OTHER" + similar_points_not_stepping_on_each_other_var.inspect
    similar_points_not_stepping_on_each_other_var.compact.sort_by { |p|

      Date.strptime(p.quote.trade_date,"%Y-%m-%d")

     }.reverse   



  end

  
  
  def to_row
    o = ""
    @chunk_data.each {|q| o = o + q.to_row }
    o
  end
  

  def last
    @chunk_data.last
  end
  
  def first
    @chunk_data.first
  end

  def find_quote(q)
    #puts "IM A TYPE: " + q.class.to_s
    @chunk_data.find_index {|h| Quote.from_openstruct(h).compare(q)}
  end

  def size
    @chunk_data.size
  end

  def data
    if (@chunk_data[0].class.to_s.include?("OpenStruct"))
      @chunk_data.map {|os| Quote.from_openstruct(os) }
    else
      @chunk_data  
    end   
  end
  
  def data_raw
      @chunk_data
  end
  
  
  def - (another_chunk)
    result = []
    self.data_raw().each_with_index{ |q,i| 
      result.push(Quote.from_openstruct(q) - Quote.from_openstruct(another_chunk.data_raw()[i]))      
    }
    result
    
  end
  
  
  
end

end