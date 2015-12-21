module Forecasting

  class DrawSelector
  
    @chunk
  
    def initialize(chunk)
      @chunk = chunk
    
    end
  
    def draw_horizontal_line(at_quote)
      similar_quotations = @chunk.select_with_index { |q,i| 
               current_quote = Quote.from_openstruct(q)
               if ((i > 0) and (i<@chunk.size))
                 ((at_quote > @chunk[i-1]) and (at_quote < @chunk[i+1])) or 
                 (at_quote.close == @chunk[i].close)
               end
              }.sort_by { |q|
                  Date.strptime(q.trade_date,"%Y-%m-%d")
              }
      similar_quotations
    end
  
  
  
  end
  
end
