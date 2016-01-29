load 'Point.rb'
load 'Chunk.rb'

module Forecasting
  class DeltaForecaster < Forecaster
    def forecast_merge(points_with_chunks)
      all_chunks = super(points_with_chunks)
      if (!all_chunks.nil?) and (!all_chunks[1].nil?) and (!all_chunks[2].nil?)
        pivot_quote = @company.last_quote
        all_left_chunks_wrapped = all_chunks[1]
        all_right_chunks_wrapped = all_chunks[2]
        min_delta_for_all_left_chunks_wrapped = calculate_min_delta_for_chunks(all_left_chunks_wrapped)
        min_delta_for_all_right_chunks_wrapped = calculate_min_delta_for_chunks(all_right_chunks_wrapped)        
        if (!min_delta_for_all_left_chunks_wrapped.nil?) and (!min_delta_for_all_left_chunks_wrapped.nil?)
          forecasting_for_next_days = Point.new(pivot_quote,min_delta_for_all_left_chunks_wrapped.set_past_dates_in_all_quotes(),min_delta_for_all_right_chunks_wrapped.set_future_dates_in_all_quotes())
          forecasting_for_next_days.amount_of_samples=(points_with_chunks.size)
          forecasting_for_next_days
        end
      else
        Forecasting::Point.new(Quote.neutral_element(),Forecasting::Chunk.new([]),Forecasting::Chunk.new([]))
      end
    end

    

    def self.accucheck_me(q1,q2)
      company = Company.new(q1.symbol)
      previous_quote_to_current_one = 
      q1 - (q1 + q2)
  
    end

    
    
    private

    def calculate_min_delta_for_chunks(chunks)
      deltas = get_deltas_for_chunks(chunks)      
      deltas.get_min_from_each_row_into_a_chunk           
    end

    
   def get_deltas_for_chunks(chunks) 
     deltas = []
     #puts "MYSIZE: " + chunks.size.to_s 
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
  
  #puts "DELTA: " + Forecasting::Chunk.new(delta).to_j
  Forecasting::Chunk.new(delta)  
end
   
   

  end

end