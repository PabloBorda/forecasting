module Enumerable
  def collect_with_index(i=0)
    collect{|elm| yield(elm, i+=1)}
  end
  alias map_with_index collect_with_index
end



module Forecasting

  class DrawSelector
  
    @chunk
  
    def initialize(chunk)
      @chunk = chunk
    
    end
  
    def draw_horizontal_line_aproximate(at_quote)   
            
      similar_quotations = @chunk.data_raw.collect_with_index { |q,i| 
               current_quote = Quote.from_openstruct(q)
               if ((!@chunk.data_raw[i-1].nil?) and (!@chunk.data_raw[i+1].nil?))
                 if (((i-1) > 0) and ((i+1)<@chunk.data_raw.size))
                   if (((at_quote > @chunk.data_raw[i-1]) and (at_quote < @chunk.data_raw[i+1])) or (at_quote.close == @chunk.data_raw[i].close))
                     @chunk.data_raw[i]   
                   end
                 end
               end  
              }.compact.sort_by { |q|
                 
                   Date.strptime(q.trade_date,"%Y-%m-%d")
                
               }
      similar_quotations
    end
  
  
    def draw_horizontal_line(at_quote)   
      #puts "DRAW HORIZONTAL LINE " + @chunk.data_raw.inspect 
            
      similar_quotations = @chunk.data_raw.compact.select { |q| 
              # #puts "DRAW HORIZONTAL LINE Q" + q.inspect
              # #puts "DRAW HORIZONTAL LINE at_quote " + at_quote.inspect
               ((q.close.to_f - at_quote.close.to_f).abs <= 0.3)
                
               }
      similar_quotations.uniq
    end
    
    
    
    
  end
  
end
