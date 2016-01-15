require 'Forecaster'
require 'Chunks'



module Forecasting
  class AvgForecaster < Forecaster


    
    
    
    protected

    def calculate_avg_for_column(column)
      count = 0
      sum_col = column.inject(0) {
        |sum,q|
        count = count + 1
        sum = sum + q.close.to_f
      }
      (sum_col/column.size)
    end


    def forecast_merge(points_with_chunks)
      all_chunks = super(points_with_chunks)
      puts "ALL_CHUNKS: " + all_chunks.size.to_s
      if (!all_chunks.nil?)
        pivot_quote = @company.last_quote
        all_left_chunks_wrapped = all_chunks[1]
        all_right_chunks_wrapped = all_chunks[2]
        forecasting_for_next_days = Point.new(pivot_quote,all_left_chunks_wrapped.calculate_avg_for_chunks,all_right_chunks_wrapped.calculate_avg_for_chunks)
        return forecasting_for_next_days
      else
        return Point.new(Quote.neutral_element(),Chunk.new([]),Chunk.new([]))  
      end
            
    end
    

    
    
  end

end