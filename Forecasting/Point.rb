require 'yahoo-finance'
require 'json'

module Forecasting
  class Point
    attr_accessor :quote
    attr_accessor :previous_n_quotes_chunk
    attr_accessor :next_n_quotes_chunk
    def initialize(quote,previous_n_quotes_chunk,next_n_quotes_chunk)
      if (!quote.nil? and !previous_n_quotes_chunk.nil? and !next_n_quotes_chunk.nil?)
        self.quote = quote
        self.previous_n_quotes_chunk = previous_n_quotes_chunk
        self.next_n_quotes_chunk = next_n_quotes_chunk
      else
        puts "NO NILS ACCEPTED"
      end
    end

    def to_deltas

      Point.new(self.quote,self.previous_n_quotes_chunk.to_deltas,self.next_n_quotes_chunk.to_deltas)

    end

    def to_html
      
      begin
     
        if (!self.previous_n_quotes_chunk.nil? and !self.next_n_quotes_chunk.nil?)

          "<table><tr><td>SYMBOL</td><td>TRADE_DATE</td><td>OPEN</td><td>CLOSE</td><td>HIGH</td><td>LOW</td><td>VOLUME</td</td><td>ADJUSTED_CLOSE</td>" + self.quote.to_row() + "</table>" + "<br><br>" + "<b>PREVIOUS CHUNK</b>" + self.previous_n_quotes_chunk.to_html() + "<b>NEXT CHUNK</b>" + self.next_n_quotes_chunk.to_html()
        else
          
          "NIL"
        end
      rescue
        puts "MYCLASSIS: " + self.previous_n_quotes_chunk.class.to_s 
        puts "MYCLASSIS: " + self.previous_n_quotes_chunk.to_html
        puts "MYCLASSIS: " + self.next_n_quotes_chunk.class.to_s
        puts "MYCLASSIS: " + self.quote.class.to_s
      end
      
    end

    def remove_repeated_prev_and_next_chunk_from_point(another_point)
      another_point.previous_n_quotes_chunk = another_point.previous_n_quotes_chunk - self.previous_n_quotes_chunk
      another_point.next_n_quotes_chunk = another_point.next_n_quotes_chunk - self.next_n_quotes_chunk
      another_point
    end

  end

end