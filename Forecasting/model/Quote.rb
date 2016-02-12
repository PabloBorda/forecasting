require 'yahoo-finance'
require 'json'

module Forecasting
  class Quote
    include Comparable

    attr_accessor :trade_date
    attr_accessor :open
    attr_accessor :close
    attr_accessor :high
    attr_accessor :low
    attr_accessor :volume
    attr_accessor :adjusted_close
    attr_accessor :symbol
    def self.from_openstruct(quote_openstruct)
      # #puts "QUOTE_OPENSTRUCT CLASS IS " + quote_openstruct.class.to_s + "     " + quote_openstruct.inspect
      if ((quote_openstruct.class.to_s.eql? "OpenStruct") or (quote_openstruct.class.to_s.eql? "Hash"))
        return Quote.new(quote_openstruct['trade_date'].to_s,quote_openstruct['open'].to_f.round(2),quote_openstruct['close'].to_f.round(2),quote_openstruct['high'].to_f.round(2),quote_openstruct['low'].to_f.round(2),quote_openstruct['volume'].to_f.round(2),quote_openstruct['adjusted_close'].to_f.round(2),quote_openstruct['symbol'].to_s)
      else
        if quote_openstruct.class.to_s.include? "Quote"
          return quote_openstruct
        end
        Forecasting::Quote.neutral_element()
      end

    end

    def self.from_ruby_hash(quote_hash)
      self.from_openstruct(quote_hash)

    end

    def self.from_json_string(quote_json_string)
      self.from_openstruct(JSON.parse(quote_json_string))
    end

    def initialize(trade_date,open,close,high,low,volume,adjusted_close,symbol)
      self.trade_date = trade_date
      self.open = open.to_f.round(2)
      self.close = close.to_f.round(2)
      self.high = high.to_f.round(2)
      self.low = low.to_f.round(2)
      self.volume = volume.to_i
      self.adjusted_close = adjusted_close.to_f.round(2)
      self.symbol = symbol
    end

    def - (q)
      #puts "RESTING: " + self.close.to_s + " AND " + q.close.to_s + " = " + (self.close - q.close).to_s
      return Quote.new(self.trade_date,self.open - q.open,self.close - q.close,self.high - q.high,self.low - q.low,self.volume - q.volume,self.adjusted_close - q.adjusted_close,self.symbol)
    end

    def + (q)
      Quote.new(self.trade_date,self.open.to_f + q.open.to_f,self.close.to_f + q.close.to_f,self.high.to_f + q.high.to_f,self.low.to_f + q.low.to_f,self.volume.to_f + q.volume.to_f,self.adjusted_close.to_f + q.adjusted_close.to_f,self.symbol)
    end

    def / (number)
      Quote.new(self.trade_date,self.open / number,self.close / number,self.high / number,self.low / number,self.volume / number,self.adjusted_close / number,self.symbol)

    end

    def self.neutral_element
      Quote.new(Time.now.strftime("%Y-%m-%d").to_s,'0'.to_f.round(2),'0'.to_f.round(2),'0'.to_f.round(2),'0'.to_f.round(2),'0'.to_i,'0'.to_f.round(2),@symbol)
    end

    def to_row

      a = "<tr><td>" + self.symbol.to_s + "</td><td>" + self.trade_date.to_s + "</td><td>" + self.open.to_s +  "</td><td>"  + self.close.to_s + "</td><td>" + self.high.to_s + "</td><td>" + self.low.to_s + "</td><td>" + self.volume.to_s + "</td><td>" + self.adjusted_close.to_s + "</td></tr>"
      a
    end

    def to_j
      "{ \"trade_date\": \"" + self.trade_date.to_s + "\",\"open\": \"" + self.open.to_s + "\",\"close\": \"" + self.close.to_s + "\",\"high\": \"" + self.high.to_s + "\",\"low\":\"" + self.low.to_s + "\",\"volume\":\"" + self.volume.to_s + "\",\"symbol\":\"" + self.symbol.to_s + "\",\"adjusted_close\":\"" + self.adjusted_close.to_s + "\"}"
    end

    def to_hash

      { :trade_date => self.trade_date,
        :open => self.open.to_f,
        :close => self.close.to_f,
        :low => self.low.to_f,
        :high => self.high.to_f,
        :volume => self.volume.to_f,
        :symbol => self.symbol.to_s,
        :adjusted_close => self.adjusted_close.to_f
      }

    end

    def compare(q)
      (self.close == q.close) &&
      (self.symbol == q.symbol) &&
      (self.trade_date.to_s.eql?(q.trade_date.to_s))
    end

    def compare_full(q)
      (self.trade_date.eql?(q.trade_date) &&
      (self.symbol == q.symbol) &&
      (self.open == q.open) &&
      (self.close == q.close) &&
      (self.high == q.high) &&
      (self.low == q.low) &&
      (self.volume == q.volume) &&
      (self.adjusted_close == q.adjusted_close))
    end

    def <=>(q)
      if ((self.close.to_f) < (q.close.to_f))
        -1
      elsif ((self.close.to_f) > (q.close.to_f))
        1
      else
        0
      end
    end

    def hash
      (self.trade_date.to_s+self.open.to_s+self.close.to_s+self.high.to_s+self.low.to_s+self.volume.to_s+self.adjusted_close.to_s+self.symbol.to_s).hash
    end

    def to_s
      self.to_row
    end

    def abs
      Quote.new(self.trade_date,self.open.abs,self.close.abs,self.high.abs,self.low.abs,self.volume.abs,self.adjusted_close.abs,self.symbol)
    end

  end

end