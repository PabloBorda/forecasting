require 'yahoo-finance'
require 'json'


require_relative 'Quote.rb'
require_relative 'Chunk.rb'

module Forecasting
  class Point

    #include Mongoid::Document
    #has_one :quote
    #has_many :chunk

    attr_accessor :previous_n_quotes_chunk
    attr_accessor :next_n_quotes_chunk
    attr_accessor :quote
    attr_accessor :amount_of_samples
    def initialize(quote,previous_n_quotes_chunk,next_n_quotes_chunk)
      if (!quote.nil? and !previous_n_quotes_chunk.nil? and !next_n_quotes_chunk.nil?)
        self.quote = quote
        self.previous_n_quotes_chunk = previous_n_quotes_chunk
        self.next_n_quotes_chunk = next_n_quotes_chunk
      else
        #puts "NO NILS ACCEPTED"
      end
    end

    def to_deltas

      Point.new(self.quote,self.previous_n_quotes_chunk.to_deltas,self.next_n_quotes_chunk.to_deltas)

    end

    def to_html

      begin

        if (!self.previous_n_quotes_chunk.nil? and !self.next_n_quotes_chunk.nil?)

          samples = ""
          if !amount_of_samples.nil?
            samples = "<td>" + amount_of_samples.to_s + "</td>"
          end

          "<table border=\"1\"><tr><td>SYMBOL</td><td>TRADE_DATE</td><td>OPEN</td><td>CLOSE</td><td>HIGH</td><td>LOW</td><td>VOLUME</td</td><td>ADJUSTED_CLOSE</td><td>SAMPLES TAKEN</td>" + self.quote.to_row() + samples + "</table>" + "<br><br>" + "<b>PREVIOUS CHUNK</b>" + self.previous_n_quotes_chunk.to_html() + "<b>NEXT CHUNK</b>" + self.next_n_quotes_chunk.to_html()
        else

          "NIL"
        end
      rescue
        #puts "MYCLASSIS: " + self.previous_n_quotes_chunk.class.to_s
        #puts "MYCLASSIS: " + self.previous_n_quotes_chunk.to_html
        #puts "MYCLASSIS: " + self.next_n_quotes_chunk.class.to_s
        #puts "MYCLASSIS: " + self.quote.class.to_s
      end

    end

    def to_j

      samples = ""
      if !amount_of_samples.nil?
        samples = ",\"amount_of_samples\": \"" + amount_of_samples.to_s + "\""
      end

      "{ \"quote\": " + self.quote.to_j + samples + ",\"previous_n_quotes_chunk\": " + self.previous_n_quotes_chunk.to_j + ",\" next_n_quotes_chunk\": " + self.next_n_quotes_chunk.to_j + "}"
    end

    def remove_repeated_prev_and_next_chunk_from_point(another_point)
      another_point.previous_n_quotes_chunk = another_point.previous_n_quotes_chunk - self.previous_n_quotes_chunk
      another_point.next_n_quotes_chunk = another_point.next_n_quotes_chunk - self.next_n_quotes_chunk
      another_point
    end

  end

end
