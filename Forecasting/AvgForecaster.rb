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
      if (!all_chunks.nil?)
        pivot_quote = @company.last_quote
        all_left_chunks_wrapped = all_chunks[1]
        all_right_chunks_wrapped = all_chunks[2]
        forecasting_for_next_days = Point.new(pivot_quote,avg_left(all_left_chunks_wrapped),avg_right(all_right_chunks_wrapped))
        return forecasting_for_next_days
      else
        return Point.new(Quote.neutral_element(),Chunk.new([]),Chunk.new([]))
      end

    end

    private

    def avg_right(chunks)
      current_trade_date = Date.today
      avg_chunk = []
      chunks.chunks[0].size.times {
        |i|
        q = Quote.new((current_trade_date + i).strftime("%Y-%m-%d").to_s,"0",self.calculate_avg_for_column(chunks.chunks.get_column_by_number(i)),"0","0","0","0",chunks.chunks.get_symbol)
        avg_chunk.push(q)
      }
      Chunk.new(avg_chunk)

    end

    def avg_left(chunks)
      current_trade_date = Date.today
      avg_chunk = []
      chunks.chunks[0].size.times {
        |i|
        q = Quote.new((current_trade_date - i).strftime("%Y-%m-%d").to_s,"0",self.calculate_avg_for_column(chunks.get_column_by_number(i)),"0","0","0","0",chunks.chunks[0].get_symbol)
        avg_chunk.push(q)
      }
      Chunk.new(avg_chunk)

    end

  end

end