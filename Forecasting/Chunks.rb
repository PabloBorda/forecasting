module Forecasting
  class Chunks
    attr_accessor :chunks
    def initialize(chunks)
      chunks = chunks
    end

    def column_from_chunks(chunks,colnum)
      column=[]
      chunks.each {
        |current_chunk|
        column.push(current_chunk.data[colnum])
      }
      column
    end

    def calculate_avg_for_chunks(chunks)
      current_trade_date = Date.today
      avg_chunk = []
      chunks[0].size.times {
        |i|
        q = Quote.new((current_trade_date + i).strftime("%Y-%m-%d").to_s,"0",calculate_avg_for_column(column_from_chunks(chunks,i)),"0","0","0","0","XXXX")
        avg_chunk.push(q)
      }
      Chunk.new(avg_chunk)

    end

    def calculate_deltas_for_chunks(chunks)
      chunks.map{|c|
        calculate_delta_for_chunk(c)
      }
    end

    def calculate_delta_for_chunk(chunk)
      delta = []
      chunk.each_with_index { |q,i|
        if (i==0)
          delta.push(q)
        else
          delta.push(q - chunk[i-1])
        end
      }
      delta
    end

    def forecast_merge_worst_drop(points_with_chunks)

    end

  end

end