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
  
    def draw_horizontal_line(at_quote)   
            
      similar_quotations = @chunk.collect_with_index { |q,i| 
               current_quote = Quote.from_openstruct(q)
               if ((!@chunk[i-1].nil?) and (!@chunk[i+1].nil?))
                 if (((i-1) > 0) and ((i+1)<@chunk.size))
                   if (((at_quote > @chunk[i-1]) and (at_quote < @chunk[i+1])) or (at_quote.close == @chunk[i].close))
                     @chunk[i]   
                   end
                 end
               end  
              }.compact.sort_by { |q|
                 
                   Date.strptime(q.trade_date,"%Y-%m-%d")
                
               }
      similar_quotations
    end
  
  
  
  end
  
end
