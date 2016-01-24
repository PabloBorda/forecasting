require 'Chunk'

module Forecasting
  class Chunks
    @chunks
    def initialize(chunks)
      @chunks = chunks
      #puts "CHUNKS SIZE IS: " + chunks.size.to_s
    end

    def get_column_by_number(colnum)
      column=[]
      @chunks.each {
        |current_chunk|
        column.push(current_chunk.data[colnum])
      }
      column
    end

    
    
    def self.from_chunk_collection_to_chunks_with_previous_dates(chunk_collection)
      
      
    end
    
    def self.from_chunk_collection_to_chunks_with_next_dates(chunk_collection)
        
        
    end
    
    
    def size
      @chunks.size
    end
    
    def get_row(i)
      @chunks.map {|c| c.get_quote_by_number(i) }                 
    end
    
    
    def get_min_from_row(i)
     
      self.get_row(i).min
    end
    
    def get_min_from_each_row_into_a_chunk
      if (chunks.size > 0)
        amount_of_chunks = @chunks[0].size
        #puts "get_min_from_each_row_into_a_chunk, amount of chunks: " + amount_of_chunks.to_s
        result = []      
        amount_of_chunks.times {|i|
          result.push(self.get_min_from_row(i))        
        }
        Forecasting::Chunk.new(result)
      else
        #puts "THERE ARE NO CHUNKS INSIDE"  
      end 
      
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
        if c.size>0
          o = o + c.to_html()
        end
      }
      o
    end

    def to_j
     
        
      if @chunks.size==0
        "[]"
      else
        p = @chunks.inject("") {|o,c|
              o = o + c.to_j + ","           
        }
      
        "[" + p[0..-2]+ "]"
      end
      
    end

  end

end