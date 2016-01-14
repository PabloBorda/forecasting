require 'Forecaster'
require 'Chunks'



module Forecasting
  class AvgForecaster < Forecaster
    def forecast_html(amount_of_days)
      points_with_chunks = super(amount_of_days)     
      output = "<br><br> Forecasting for the next days <br><br> Average algorithm<br>" + self.forecast_merge(points_with_chunks).unless_nil(&:to_html)
      output
    end

    def forecast_json(amount_of_days)
      points_with_chunks = super.forecast_json(amount_of_days)

    end

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
        pivot_quote = all_chunks[0]
        all_left_chunks_wrapped = all_chunks[1]
        all_right_chunks_wrapped = all_chunks[2]
        forecasting_for_next_days = Point.new(pivot_quote,all_left_chunks_wrapped.calculate_avg_for_chunks,all_right_chunks_wrapped.calculate_avg_for_chunks)
      end      
    end
    

    
    
  end

end