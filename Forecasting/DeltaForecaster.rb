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
        forecasting_for_next_days = Point.new(pivot_quote,calculate_min_delta_for_chunks(all_left_chunks_wrapped).set_past_dates_in_all_quotes(),calculate_min_delta_for_chunks(all_right_chunks_wrapped).set_future_dates_in_all_quotes())
        forecasting_for_next_days
      else
        Forecasting::Point.new(Quote.neutral_element(),Forecasting::Chunk.new([]),Forecasting::Chunk.new([]))
      end
    end

    private

    def calculate_min_delta_for_chunks(chunks)
      deltas = get_deltas_for_chunks(chunks)      
      deltas.get_min_from_each_row_into_a_chunk           
    end

    
   def get_deltas_for_chunks(chunks) 
     deltas = []
     puts "MYSIZE: " + chunks.size.to_s 
     chunks.chunks.each {|c|
       deltas.push(to_deltas(c))        
     }
     Forecasting::Chunks.new(deltas)
     
   end
    
    
   


def to_deltas(chunk)
  delta = []
  chunk.data.each_with_index { |q,i| 
    if (i==0)
      delta.push(q)        
    else
      delta.push(q - Quote.from_openstruct(chunk.data[i-1]))
    end
  }    
  Forecasting::Chunk.new(delta)  
end
   
   

  end

end