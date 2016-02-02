require_relative 'Forecaster.rb'
require_relative '../model/Chunks.rb'

module Forecasting
  class AvgForecaster < Forecaster
    def self.accucheck_me(q1,q2)
      q1 - q2

    end

    protected

    def calculate_avg_for_column(column)
      count = 0
      #puts "CALCULATING AVG FOR COLUMN: " + column.inspect
      sum_col = column.inject(0) {
        |sum,q|
        count = count + 1
        sum = sum + q.close.to_f
      }
      #puts "AVERAGE IS: " + (sum_col/count).to_s
      (sum_col/count)
    end

    def forecast_merge(points_with_chunks)
      all_chunks = super(points_with_chunks)
      if (!all_chunks.nil?)
        pivot_quote = @company.last_quote
        all_left_chunks_wrapped = all_chunks[1]
        all_right_chunks_wrapped = all_chunks[2]
        forecasting_for_next_days = Point.new(pivot_quote,avg_left(all_left_chunks_wrapped),avg_right(all_right_chunks_wrapped))
        forecasting_for_next_days.amount_of_samples=(points_with_chunks.size)
        return forecasting_for_next_days
      else
        return Point.new(Quote.neutral_element(),Chunk.new([]),Chunk.new([]))
      end

    end

    private

    def avg_right(chunks)
      current_trade_date = Date.today
      avg_chunk = []
      if chunks.size > 0
        chunks.chunks[0].size.times {
          |i|
          q = Quote.new("","0",self.calculate_avg_for_column(chunks.get_column_by_number(i)),"0","0","0","0",chunks.chunks[0].get_symbol)
          avg_chunk.push(q)
        }
      end
      c = Chunk.new(avg_chunk)
      c.set_future_dates_in_all_quotes()

    end

    def avg_left(chunks)
      current_trade_date = Date.today
      avg_chunk = []
      if chunks.size > 0
        chunks.chunks[0].size.times {
          |i|
          q = Quote.new("","0",self.calculate_avg_for_column(chunks.get_column_by_number(i)),"0","0","0","0",chunks.chunks[0].get_symbol)
          avg_chunk.push(q)
        }
      end
      c = Chunk.new(avg_chunk)
      c.set_past_dates_in_all_quotes()

    end

  end

end
