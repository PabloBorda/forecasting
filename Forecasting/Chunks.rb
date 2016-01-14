require 'Chunk'

module Forecasting
  class Chunks
    @chunks
    def initialize(chunks)
      @chunks = chunks
      puts "CHUNK SIZE IS: " + chunks.size.to_s
    end

    def column_from_chunks(chunks,colnum)
      column=[]
      chunks.each {
        |current_chunk|
        column.push(current_chunk.data[colnum])
      }
      column
    end

    def calculate_avg_for_chunks()
      current_trade_date = Date.today
      avg_chunk = []
      @chunks[0].size.times {
        |i|
        q = Quote.new((current_trade_date + i).strftime("%Y-%m-%d").to_s,"0",self.calculate_avg_for_column(column_from_chunks(@chunks,i)),"0","0","0","0","XXXX")
        avg_chunk.push(q)
      }
      Chunk.new(avg_chunk)

    end

    def calculate_deltas_for_chunks(chunks)
      @chunks.map{|c|
        calculate_delta_for_chunk(c)
      }
    end

    def calculate_delta_for_chunks
      delta = []
      @chunks.each_with_index { |q,i|
        if (i==0)
          delta.push(q)
        else
          delta.push(q - @chunks[i-1])
        end
      }
      Forecasting::Chunks.new(delta)
    end

    def forecast_merge_worst_drop(points_with_chunks)

    end

    

    def calculate_avg_for_column(column)
      count = 0
      sum_col = column.inject(0) {
        |sum,q|
        count = count + 1
        sum = sum + q.close.to_f
      }
      (sum_col/column.size)
    end
    
    
    def to_html
      o = ""
      @chunks.each {|c|        
          o = o + c.to_html()        
      }
      o
      
      
    end
    

  end

end