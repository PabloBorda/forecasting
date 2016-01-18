require 'Point'
require 'Chunk'

module Forecasting
  class DeltaForecaster < Forecaster
    def forecast_merge(points_with_chunks)
      all_chunks = super(points_with_chunks)
      if (!all_chunks.nil?)
        pivot_quote = @company.last_quote
        all_left_chunks_wrapped = all_chunks[1]
        all_right_chunks_wrapped = all_chunks[2]
        forecasting_for_next_days = Point.new(pivot_quote,calculate_min_delta_for_chunks(all_left_chunks_wrapped),calculate_min_delta_for_chunks(all_right_chunks_wrapped))
        forecasting_for_next_days
      else
        Forecasting::Point.new(Quote.neutral_element(),Forecasting::Chunk.new([]),Forecasting::Chunk.new([]))
      end
    end

    private

    def calculate_min_delta_for_chunks(chunks)
      deltas = []
      chunks.chunks.each {|c|
        deltas.push(calculate_delta_for_single_chunk(c))
      }
      
     total_delta = []
     
     close_lowest = 9999999
     quote_lowest = nil
      
     
        
     deltas.size().times {|i|
      deltas[i].size.times { |j|
        if deltas[i].get_quote_by_number(j).close.to_f <= close_lowest.to_f
          quote_lowest = deltas[i].get_quote_by_number(j)
        end
      }
      total_delta.push(quote_lowest)      
    }
    
    Forecasting::Chunk.new(total_delta)
      
      
    end


    
    
    
    def calculate_delta_for_single_chunk(chunk)
      chunk.to_deltas               
    end
    
    
    
    
    
    
    
    
    
    

  end

end