require 'yahoo-finance'
require 'json'
require 'byebug'

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
    Quote.new(quote_openstruct['trade_date'].to_s,quote_openstruct[:open].to_f,quote_openstruct[:close].to_f,quote_openstruct['high'].to_f,quote_openstruct['low'].to_f,quote_openstruct['volume'].to_f,quote_openstruct['adjusted_close'].to_f,quote_openstruct['symbol'].to_s)


  end




  def initialize(trade_date,open,close,high,low,volume,adjusted_close,symbol)
    self.trade_date = trade_date
    self.open = open.to_f
    self.close = close.to_f
    self.high = high.to_f
    self.low = low.to_f
    self.volume = volume.to_i
    self.adjusted_close = adjusted_close.to_f
    self.symbol = symbol
  end

  def - (q)
    Quote.new(self.trade_date,self.open - q.open,self.close - q.close,self.high - q.high,self.low - q.low,self.volume - q.volume,self.adjusted_close - q.adjusted_close,self.symbol)
  end


  def + (q)
    Quote.new(self.trade_date,self.open + q.open,self.close + q.close,self.high + q.high,self.low + q.low,self.volume + q.volume,self.adjusted_close + q.adjusted_close,self.symbol)
 end
 
  def / (number)
    Quote.new(self.trade_date,self.open / number,self.close / number,self.high / number,self.low / number,self.volume / number,self.adjusted_close / number,self.symbol)

  end



  def self.neutral_element
     Quote.new(Time.now.strftime("%Y-%m-%d").to_s,'0'.to_f,'0'.to_f,'0'.to_f,'0'.to_f,'0'.to_i,'0'.to_f,@symbol)
  end



  def to_row

    "<tr><td>" + self.symbol.to_s + "</td><td>" + self.trade_date.to_s + "</td><td>" + self.open.to_s +  "</td><td>"  + self.close.to_s + "</td><td>" + self.high.to_s + "</td><td>" + self.low.to_s + "</td><td>" + self.volume.to_s + "</td><td>" + self.adjusted_close.to_s + "</td></tr>"
  end


  
  def compare(q)
    (self.trade_date == q.trade_date) &&
    (self.open == q.open) &&
    (self.close == q.close) &&
    (self.high == q.high) &&
    (self.low == q.low) &&
    (self.volume == q.volume) &&
    (self.adjusted_close == q.adjusted_close) &&
    (self.symbol == q.symbol)
  end



  def <=>(q)
    if (((self.high+self.low)/2) < ((q.high+q.low)/2))
      -1
    elsif (((self.high+self.low)/2) > ((q.high+q.low)/2))
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





class Chunk

  
  @chunk_data
  def initialize(chunk)
    @chunk_data = chunk
  end
  

  def to_html
    
    (@chunk_data.inject ("<table><tr><td>SYMBOL</td><td>TRADE_DATE</td><td>OPEN</td><td>CLOSE</td><td>HIGH</td><td>LOW</td><td>VOLUME</td</td><td>ADJUSTED_CLOSE</td>") {|o,q|
       o = o + Quote.from_openstruct(q).to_row
    }) + "</table>"
  
  end
  

  def self.to_html(chunk)
    Chunk.new(chunk).to_html
  end


  def to_deltas
    delta = []
    @chunk_data.each_with_index { |q,i| 
      if (i==0)
        delta.push(q)        
      else
        delta.push(q - Quote.from_openstruct(@chunk_data[i-1]))
      end
    }    
    delta  
  end

  def similar_points_not_stepping_on_each_other(last_quote,amount_of_days)
    #Sort quotes by similarity with current quote, and then sort by date descendant

    similar_quotations = @chunk_data.sort_by { |q| 
     (Quote.from_openstruct(q) - last_quote).abs
    }.sort_by { |q|
      Date.strptime(q.trade_date,"%Y-%m-%d")
    }
    similar_quotations_reverse = similar_quotations.reverse
    similar_quotations_reverse_first_element_removed = similar_quotations_reverse[1..-1]
    similar_quotations = similar_quotations_reverse_first_element_removed[0..amount_of_days].map {|q| Quote.from_openstruct(q) }
    similar_points_stepping_on_each_other = []
   

    point_count = 0
    while (point_count<(similar_quotations.size)) do
      current_quote = similar_quotations[point_count]
      #puts "CURRENT DATA: " + @chunk_data.class.to_s  
      current_quote_position_in_all_quotes = @chunk_data.find_index {|q| Quote.from_openstruct(q).compare(current_quote) }
      previous_chunk_from_current_quote = @chunk_data[current_quote_position_in_all_quotes-amount_of_days..current_quote_position_in_all_quotes-1]
    #puts "previous_chunk_from_current_quote: " + previous_chunk_from_current_quote.inspect
      next_chunk_from_current_quote = @chunk_data[current_quote_position_in_all_quotes+1..current_quote_position_in_all_quotes+amount_of_days]
    puts "next_chunk_from_current_quote: " + next_chunk_from_current_quote.inspect
      similar_points_stepping_on_each_other.push(Point.new(current_quote,previous_chunk_from_current_quote,next_chunk_from_current_quote))
    
      point_count = point_count + 1

    end
   # puts "POINTS STEPING ON EACH OTHER" + similar_points_stepping_on_each_other.inspect
   
    similar_points_not_stepping_on_each_other_var = []
  
  similar_points_stepping_on_each_other.each_with_index.map {|p,i|
      count = i+1     
      while (!similar_points_stepping_on_each_other[count].nil?) do 
         p1 = similar_points_stepping_on_each_other[count]     
         p.remove_repeated_prev_and_next_chunk_from_point(p1)
     similar_points_not_stepping_on_each_other_var.push(p)
         count = count + 1
      end

    }

    puts "POINTS NOT STEPING ON EACH OTHER" + similar_points_not_stepping_on_each_other_var.inspect
    similar_points_not_stepping_on_each_other_var



  end



  def last
    @chunk_data.last
  end

  def find_quote(q)
    #puts "IM A TYPE: " + q.class.to_s
    @chunk_data.find_index {|h| Quote.from_openstruct(h).compare(q)}
  end

  def size
    @chunk_data.size
  end

  def data
    @chunk_data
  end
  
end






class Point

  attr_accessor :quote
  attr_accessor :previous_n_quotes_chunk
  attr_accessor :next_n_quotes_chunk



  def initialize(quote,previous_n_quotes_chunk,next_n_quotes_chunk)
    self.quote = quote
    self.previous_n_quotes_chunk = previous_n_quotes_chunk
    self.next_n_quotes_chunk = next_n_quotes_chunk
  end


  def to_deltas

    Point.new(self.quote,self.previous_n_quotes_chunk.to_deltas,self.next_n_quotes_chunk.to_deltas)


  end

  def to_html
    "<table><tr><td>SYMBOL</td><td>TRADE_DATE</td><td>OPEN</td><td>CLOSE</td><td>HIGH</td><td>LOW</td><td>VOLUME</td</td><td>ADJUSTED_CLOSE</td>" + self.quote.to_row + "</table>" + "<br><br>" + "<b>PREVIOUS CHUNK</b>" + self.previous_n_quotes_chunk.to_html + "<b>NEXT CHUNK</b>" + self.next_n_quotes_chunk.to_html

  end



  def remove_repeated_prev_and_next_chunk_from_point(another_point)
    another_point.previous_n_quotes_chunk = another_point.previous_n_quotes_chunk - self.previous_n_quotes_chunk
    another_point.next_n_quotes_chunk = another_point.next_n_quotes_chunk - self.next_n_quotes_chunk
    another_point
  end


end





class Company

  @symbol
  @yahoo_client
  @history

  def initialize(symbol)
    @yahoo_client = YahooFinance::Client.new
    @symbol = symbol
    @history = nil
  end

  def all_history
    if @history.nil?
      @history = @yahoo_client.historical_quotes(@symbol)
    end
    @history.map{|q| 
      Quote.new(q['trade_date'],q['open'],q['close'],q['high'],q['low'],q['volume'],q['adjusted_close'],q['symbol'])
    } 
    Chunk.new(@history)
  end



  def all_history_between(period)
      data = @yahoo_client.historical_quotes(@symbol,period)
      data.map{|q|
        Quote.new(q['trade_date'],q['open'],q['close'],q['high'],q['low'],q['volume'],q['adjusted_close'],q['symbol'])
      }
      Chunk.new(data)
  end

  def current_quote_realtime
    data = @yahoo_client.quote(@symbol, [:ask_real_time])
    data.ask_real_time.to_s    
  end

  def last_quote
    l = self.all_history_between({ start_date: Time::now-(24*60*60*7), end_date: Time::now }).last
    #puts "LASTQUOTE " + l.inspect
#    Quote.new(l['trade_date'],l['open'],l['close'],l['high'],l['low'],l['volume'],l['adjusted_close'],l['symbol'])
    Quote.from_openstruct(l)
  end


  def forecast_html(amount_of_days)
    forecast(amount_of_days,"html")
  end
  
  
  
  def forecast_json(amount_of_days)
    forecast(amount_of_days,"json")
  end


  private
  
  def forecast(amount_of_days,format)
    current_date = Time.now.strftime("%Y-%m-%d")
    last_quote = self.last_quote
    
    

    points_from_line = self.all_history.similar_points_not_stepping_on_each_other(last_quote,amount_of_days)[0..(amount_of_days*2-1)]
     
  
  points_with_chunks = []
 
    points_from_line.each {|p|
      if !p.nil?
        #puts "q has " + q.inspect
        #puts "all history has " + self.all_history.inspect
      #puts "q class is: "  + q.class.to_s
        p_index_in_all_history = self.all_history.find_quote(p.quote)
        if !p_index_in_all_history.nil?
          next_chunk = Chunk.new(self.all_history.data[(p_index_in_all_history-amount_of_days-1)..(p_index_in_all_history-1)])
          previous_chunk = Chunk.new(self.all_history.data[(p_index_in_all_history+1)..(p_index_in_all_history+amount_of_days+1)])
          points_with_chunks.push(Point.new(p.quote,previous_chunk,next_chunk))
        end
      end
    } 
    output = "AMOUNT OF QUOTES " + self.all_history.size.to_s + " <br> LAST QUOTE <br>" + last_quote.to_s + "<br>"
    output = output + "<b>RETRIEVED POINTS AND ITS PREVIOUS AND NEXT CHUNKS</b><br>"
    
  if (format.eql? "html")
   points_with_chunks.each {|p|
      
      output = output + "<b>MY POINT</b><br>"  + p.to_html

     }      
  else
    if (format.eql? "json")
      output = points_with_chunks.inspect
    end
  end
  
  output 
    

  end
  
    
  
  

    def find_object

    end

    def column_from_chunks(chunks,colnum)
      column=[]
      chunks.each {
        |current_chunk|
        column.push(current_chunk[colnum])
      }
      column
    end

    
    def calculate_avg_for_column(column)
     count = 0
      sum_col = column.inject(Quote.neutral_element) {
        |sum,q|
       count = count + 1
        sum = sum + q
      }
      (sum_col/column.size)
    end


    def calculate_avg_for_chunks(chunks)
      current_trade_date = Date.today
      avg_chunk = []
      chunks[0].size.times {
        |i|
        calculated_chunk = calculate_avg_for_column(column_from_chunks(chunks,i)) 
        calculated_chunk.trade_date = (current_trade_date + i).strftime("%Y-%m-%d").to_s
                
        avg_chunk.push(calculated_chunk)
      }
      avg_chunk

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

    



end

end


company = Forecasting::Company.new("AAPL")
history = company.forecast_html(20)



#puts history
#puts company.all_history_between({ start_date: Time::now-(24*60*60*10), end_date: Time::now })
#puts company.current_quote
