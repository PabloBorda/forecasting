module Forecasting
  class Forecaster

    @company
    def initialize(company)
      @company = company
    end

    def forecast_html(amount_of_days)
      self.forecast(amount_of_days)

    end

    def forecast_json(amount_of_days)
      self.forecast(amount_of_days)

    end

    protected

    def forecast(amount_of_days)
      current_date = Time.now.strftime("%Y-%m-%d")
      last_quote = @company.last_quote

      #puts "LAST QUOTE IS " + last_quote.inspect

      points_from_line = @company.all_history.similar_points_not_stepping_on_each_other(last_quote,amount_of_days)[0..(amount_of_days*2-1)]

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

      #puts "POINTS WITH CHUNKS: " + points_with_chunks.inspect
      puts "POINTS WITH CHUNKS: " + points_with_chunks.size.to_s
      points_with_chunks
      
    end

    def forecast_merge(points_with_chunks)
      if (points_with_chunks.size>0)
        pivot_quote = points_with_chunks[0].quote
        all_left_chunks = []
        all_right_chunks = []
        points_with_chunks.each {|p| all_left_chunks.push(p.previous_n_quotes_chunk) }
        points_with_chunks.each {|p| all_right_chunks.push(p.next_n_quotes_chunk) }

        all_left_chunks_wrapped = Forecasting::Chunks.new(all_left_chunks)
        all_right_chunks_wrapped = Forecasting::Chunks.new(all_right_chunks)

        [pivot_quote,all_left_chunks_wrapped,all_right_chunks_wrapped]

      else
        nil  
      end

    end

  end

end