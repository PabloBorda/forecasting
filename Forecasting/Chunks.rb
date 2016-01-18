require 'Chunk'

module Forecasting
  class Chunks
    @chunks
    def initialize(chunks)
      @chunks = chunks
      puts "CHUNK SIZE IS: " + chunks.size.to_s
    end

    def get_column_by_number(colnum)
      column=[]
      @chunks.each {
        |current_chunk|
        column.push(current_chunk.data[colnum])
      }
      column
    end



    def chunks
      @chunks
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
        if !c.class.to_s.include? "Array"
          o = o + c.to_html()
        end
      }
      o
    end

    def to_j
      o = "[" + 
      p = @chunks.inject("") {|o,c|
        
          o = o + c.to_j + "," 
        
      }
      
      "[" + p[0..-2]+ "]"
      
    end

  end

end