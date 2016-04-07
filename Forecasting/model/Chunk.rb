require 'yahoo-finance'
require 'json'

require_relative '../algorithms/selectors/DrawSelector.rb'

module Forecasting
  class Chunk

    @chunk_data

    @selector
    def initialize(chunk)
      if (chunk.class.to_s.include? "Chunk")
        puts "YOU INSERTING A CHUNK!"
      end
      @chunk_data = chunk.compact

      @selector = DrawSelector.new(self)

    end


    
    
    def min_historic_value
      ::Forecasting::Quote::from_openstruct(@chunk_data.min do |p,q|
                                              p[:close] <=> q[:close]
                                            end)                                                                                                   
    end
    
    def max_historic_value
      ::Forecasting::Quote::from_openstruct(@chunk_data.max do |p,q|
                                              p[:close] <=> q[:close]
                                            end)                                                                                                   
    end    
    
    
    
    
    
    
    def set_future_dates_in_all_quotes
      current_trade_date = Date.today - 1
      @chunk_data = @chunk_data.map {|q|
        current_trade_date = current_trade_date + 1
        while (((current_trade_date).wday == 6) or ((current_trade_date).wday == 0))
          current_trade_date = current_trade_date + 1
        end
        q.trade_date = ((current_trade_date).strftime("%Y-%m-%d").to_s)
        q
      }
      self

    end

    def set_past_dates_in_all_quotes
      current_trade_date = Date.today - 1
      @chunk_data = @chunk_data.map {|q|
        current_trade_date = current_trade_date - 1
        while  (((current_trade_date).wday == 0) or ((current_trade_date).wday == 6))
          current_trade_date = current_trade_date - 1
        end
        q.trade_date = ((current_trade_date).strftime("%Y-%m-%d").to_s)
        q
      }
      self
    end

    def to_html

      (@chunk_data.compact.inject("<table border=\"1\"><tr><td>SYMBOL</td><td>TRADE_DATE</td><td>OPEN</td><td>CLOSE</td><td>HIGH</td><td>LOW</td><td>VOLUME</td</td><td>ADJUSTED_CLOSE</td>") {|o,q|
        ##puts "Q: " + q.inspect
        if (q.class.to_s.include? "Chunk")
          #puts "YOU INSERTING A CHUNK!"
        end
        o = o + Quote.from_openstruct(q).to_row.to_s
      }) + "</table>"

    end

    def self.to_html(chunk)
      Chunk.new(chunk).to_html
    end

    def to_j
      if @chunk_data.size>1
        o = @chunk_data.inject(""){|o,q| if q.class.to_s.include? "Quote"
            o = o + "," + q.to_j
          else
            o = o + "," + Quote.from_openstruct(q).to_j
          end
        }
        ("[" + o[1..-1] + "]")
      else
        "[]"
      end

    end

    def get_quote_by_number(i)
      Quote.from_openstruct(@chunk_data[i])
    end

    def similar_points_not_stepping_on_each_other(last_quote,amount_of_days)
      #Sort quotes by similarity with current quote, and then sort by date descendant

      similar_quotations = @selector.draw_horizontal_line(last_quote)

      similar_quotations_reverse = similar_quotations.reverse
      similar_quotations_reverse_first_element_removed = similar_quotations_reverse[1..-1]
      similar_quotations = similar_quotations_reverse_first_element_removed[0..amount_of_days].map {|q| Quote.from_openstruct(q) }

      # #puts "SIMILAR QUOTATIONS ARE " + similar_quotations.to_json
      similar_points_stepping_on_each_other = []

      point_count = 0
      while (point_count<(similar_quotations.size)) do
        current_quote = similar_quotations[point_count]
        current_quote_position_in_all_quotes = @chunk_data.find_index {|q| Quote.from_openstruct(q).compare(current_quote) }

        prev_lower_limit = 0
        prev_upper_limit = 0
        next_lower_limit = current_quote_position_in_all_quotes + 1
        next_upper_limit = @chunk_data.size

        if (current_quote_position_in_all_quotes!=0)

          if ((current_quote_position_in_all_quotes - 1 - amount_of_days) >= 0)
            prev_lower_limit = (current_quote_position_in_all_quotes - 1 - amount_of_days)
            prev_upper_limit = current_quote_position_in_all_quotes - 1
          else
            prev_lower_limit = 0
            prev_upper_limit = current_quote_position_in_all_quotes - 1
          end

          previous_chunk_from_current_quote = @chunk_data[prev_lower_limit..prev_upper_limit]
        else
          previous_chunk_from_current_quote = []
        end

        if (current_quote_position_in_all_quotes!=@chunk_data.size)

          if ((current_quote_position_in_all_quotes + 1 + amount_of_days) < @chunk_data.size)
            next_lower_limit = current_quote_position_in_all_quotes + 1
            next_upper_limit = current_quote_position_in_all_quotes + 1 + amount_of_days
          else
            next_lower_limit = current_quote_position_in_all_quotes + 1
            next_upper_limit = @chunk_data.size
          end

          next_chunk_from_current_quote = @chunk_data[next_lower_limit..next_upper_limit]

        else
          next_chunk_from_current_quote = []
        end
        #  #puts "next_chunk_from_current_quote: " + next_chunk_from_current_quote.inspect
        similar_points_stepping_on_each_other.push(Point.new(current_quote,previous_chunk_from_current_quote,next_chunk_from_current_quote))
        point_count = point_count + 1

      end

      similar_points_not_stepping_on_each_other_var = []

      similar_points_stepping_on_each_other.each_with_index.map {|p,i|
        count = i+1
        if (!similar_points_stepping_on_each_other[count].nil?)
          p1 = similar_points_stepping_on_each_other[count]
          p.remove_repeated_prev_and_next_chunk_from_point(p1)
          similar_points_not_stepping_on_each_other_var.push(p)
        end

      }

      #   #puts "POINTS NOT STEPING ON EACH OTHER" + similar_points_not_stepping_on_each_other_var.inspect
      similar_points_not_stepping_on_each_other_var.compact.sort_by { |p|

        Date.strptime(p.quote.trade_date,"%Y-%m-%d")

      }.reverse

    end

    def to_row
      o = ""
      @chunk_data.each {|q| o = o + q.to_row }
      o
    end

    def to_hashes
      self.data.map do |q|
        q.to_hash
      end
    end
    
    
    
    def last
      @chunk_data.last
    end

    def first

      @chunk_data.first
    end

    def find_quote(q)
      ##puts "IM A TYPE: " + q.class.to_s
      @chunk_data.find_index {|h| Quote.from_openstruct(h).compare(q)}
    end

    def size
      @chunk_data.size
    end

    def data
      if (@chunk_data[0].class.to_s.include?("OpenStruct"))
        @chunk_data.map {|os| Quote.from_openstruct(os) }
      else
        @chunk_data
      end
    end

    def data_raw
      @chunk_data
    end

    def get_symbol
      @chunk_data[0].symbol
    end

    def - (another_chunk)
      ##puts "RESTING CHUNK" + self.inspect + " WITH " + another_chunk.inspect
      result = []
      self.data_raw().each_with_index{ |q,i|
        result.push(Quote.from_openstruct(q) - Quote.from_openstruct(another_chunk.data_raw()[i]))
      }
      Forecasting::Chunk.new(result)

    end

  end

end