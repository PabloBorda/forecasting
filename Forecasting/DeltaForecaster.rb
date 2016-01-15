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
        forecasting_for_next_days = Point.new(pivot_quote,calculate_delta_for_chunks(all_left_chunks_wrapped),calculate_delta_for_chunks(all_right_chunks_wrapped))
        forecasting_for_next_days
      else
        Forecasting::Point.new(Quote.neutral_element(),Forecasting::Chunk.new([]),Forecasting::Chunk.new([]))
      end
    end

    
    
    
    
    private

    
    
    def calculate_deltas_for_chunks(chunks)
      chunks.chunks.map{|c|
        calculate_delta_for_chunk(c)
      }
    end

    def calculate_delta_for_chunks(chunks)
      delta = []
      chunks.chunks.each_with_index { |q,i|
        puts "Q IS A CHUNK: " + q.class.to_s
        if (i==0)
          delta.push(q)
        else
          delta.push(q - chunks.chunks[i-1])
        end
      }
      Forecasting::Chunks.new(delta).calculate_avg_for_chunks
    end

    
    
    
    
    
    
    
    
    
  end

end