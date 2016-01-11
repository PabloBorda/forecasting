require 'Forecaster'

module Forecasting
  class AvgForecaster < Forecaster
    def forecast_html(amount_of_days)
      points_with_chunks = super(amount_of_days)
      output = output + "<br><br> Forecasting for the next days <br><br>" + self.forecast_merge_avg(points_with_chunks).to_html()
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

    def forecast_merge_avg(points_with_chunks)
      pivot_quote = points_with_chunks[0].quote
      all_left_chunks = []
      all_right_chunks = []
      points_with_chunks.each {|p| all_left_chunks.push(p.previous_n_quotes_chunk) }
      points_with_chunks.each {|p| all_right_chunks.push(p.next_n_quotes_chunk) }

      forecasting_for_next_days = Point.new(pivot_quote,calculate_avg_for_chunks(all_left_chunks),calculate_avg_for_chunks(all_right_chunks))

    end

  end

end