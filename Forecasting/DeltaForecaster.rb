require 'Point'
require 'Chunk'

module Forecasting
  class DeltaForecaster < Forecaster
    def forecast_html(amount_of_days)
      points_with_chunks = super(amount_of_days)
      html = self.forecast_merge(points_with_chunks).to_html
      output = ""
      if !html.nil?
        output = "<br><br> Forecasting for the next days <br><br>" + html
      end
      output
    end

    def forecast_json(amount_of_days)
      points_with_chunks = super.forecast_json(amount_of_days)

    end

    def forecast_merge(points_with_chunks)
      all_chunks = super(points_with_chunks)
      #puts "ALL_CHUNKS: " + all_chunks.inspect
      if (!all_chunks.nil?)
        pivot_quote = all_chunks[0]
        puts "pivot_quote: " + pivot_quote.inspect
        all_left_chunks_wrapped = all_chunks[1]
        puts "all_left: " + all_left_chunks_wrapped.inspect
        all_right_chunks_wrapped = all_chunks[2]
        puts "all_right: " + all_right_chunks_wrapped.inspect
        forecasting_for_next_days = Point.new(pivot_quote,all_left_chunks_wrapped.calculate_delta_for_chunks,all_right_chunks_wrapped.calculate_delta_for_chunks)
        puts "FORECASTING NEXT DAYS: " + forecasting_for_next_days.inspect
        forecasting_for_next_days
      else
        Forecasting::Point.new(Quote.neutral_element(),Forecasting::Chunk.new([]),Forecasting::Chunk.new([]))
      end
    end

  end

end