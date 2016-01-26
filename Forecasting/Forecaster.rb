module Forecasting
  class Forecaster

    @company
    @amount_of_days
    def initialize

    end

    def forecast_on_me(company,amount_of_days)
      @company = company
      @company.all_history
      @amount_of_days = amount_of_days
      self.forecast_merge(self.forecast(amount_of_days))
    end

    def accuracy

    end

    def amount_of_days
      @amount_of_days
    end

    protected

    def forecast(amount_of_days)
      if !@company.all_history.nil?
        current_date = Time.now.strftime("%Y-%m-%d")
        last_quote = @company.last_quote

        ##puts "LAST QUOTE IS " + last_quote.inspect

        points_from_line = @company.all_history.similar_points_not_stepping_on_each_other(last_quote,amount_of_days)[0..(amount_of_days*2-1)]
        ##puts "POINTS_FROM_LINE: " + points_from_line.size.to_s
        points_with_chunks = []

        points_from_line.each {|p|
          if !p.nil?
            p_index_in_all_history = @company.all_history.find_quote(p.quote)
            if !p_index_in_all_history.nil?
              a = []
              b = []
              next_chunk = Chunk.new(a)
              previous_chunk = Chunk.new(b)
              if (((p_index_in_all_history-amount_of_days-1)>=0) and
              ((p_index_in_all_history-1)<@company.all_history.size))
                next_chunk = Chunk.new(@company.all_history.data[(p_index_in_all_history-amount_of_days-1)..(p_index_in_all_history-1)].reverse)
              end
              if (((p_index_in_all_history+1)>=0) and
              ((p_index_in_all_history+amount_of_days+1)<@company.all_history.size))
                previous_chunk = Chunk.new(@company.all_history.data[(p_index_in_all_history+1)..(p_index_in_all_history+amount_of_days+1)].reverse)
              end
              points_with_chunks.push(Point.new(p.quote,previous_chunk,next_chunk))
            end
          end
        }

        points_with_chunks = points_with_chunks.compact
        #puts "POINTS_WITH_CHUNKS" + (points_with_chunks.inject("["){|o,p| o = o + p.to_j + ","})[0..-2] + "]"

        points_with_chunks
      end
    end

    def forecast_merge(points_with_chunks)
      if !@company.all_history.nil?
        if (points_with_chunks.size>0)
          pivot_quote = points_with_chunks[0].quote
          all_left_chunks = []
          all_right_chunks = []
          points_with_chunks.each {|p|
            if (p.previous_n_quotes_chunk.size > 0) and (p.next_n_quotes_chunk.size>0)
              all_left_chunks.push(p.previous_n_quotes_chunk)
              all_right_chunks.push(p.next_n_quotes_chunk)
            end
          }
          all_left_chunks_wrapped = Forecasting::Chunks.new(all_left_chunks)
          all_right_chunks_wrapped = Forecasting::Chunks.new(all_right_chunks)

          [pivot_quote,all_left_chunks_wrapped,all_right_chunks_wrapped,points_with_chunks]

        else
          nil
        end
      end
    end

  end

end