require 'yahoo-finance'
require 'json'


module Forecasting

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
      
      puts "YAHOO " + data.inspect
      Chunk.new(data)
  end

  def current_quote_realtime
    data = @yahoo_client.quote(@symbol, [:ask_real_time])
    data.ask_real_time.to_s    
  end

  def last_quote
    l = self.all_history_between({ start_date: Time::now-(24*60*60*7), end_date: Time::now }).first
    puts "LASTQUOTE " + l.inspect
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
  
  
  
  def forecast_merge_avg(points_with_chunks)
    pivot_quote = points_with_chunks[0].quote
    all_left_chunks = []
    all_right_chunks = []
    points_with_chunks.each {|p| all_left_chunks.push(p.previous_n_quotes_chunk) }
    points_with_chunks.each {|p| all_right_chunks.push(p.next_n_quotes_chunk) }
    
    forecasting_for_next_days = Point.new(pivot_quote,calculate_avg_for_chunks(all_left_chunks),calculate_avg_for_chunks(all_right_chunks))
    
    
  end
  
  
  def forecast_merge_worst_drop(points_with_chunks)
    
    
    
  end
  
  
  
  
  
  
  
  
  
  def forecast(amount_of_days,format)
    current_date = Time.now.strftime("%Y-%m-%d")
    last_quote = self.last_quote
    
    puts "LAST QUOTE IS " + last_quote.inspect

    points_from_line = self.all_history.similar_points_not_stepping_on_each_other(last_quote,amount_of_days)[0..(amount_of_days*2-1)]
     
  
  points_with_chunks = []
 
    points_from_line.each {|p|
      if !p.nil?
        p_index_in_all_history = self.all_history.find_quote(p.quote)
        if !p_index_in_all_history.nil?
          a = []
          b = []
          next_chunk = Chunk.new(a)          
          previous_chunk = Chunk.new(b)
          if (((p_index_in_all_history-amount_of_days-1)>=0) and
              ((p_index_in_all_history-1)<self.all_history.size)) 
            next_chunk = Chunk.new(self.all_history.data[(p_index_in_all_history-amount_of_days-1)..(p_index_in_all_history-1)].reverse)
          end
          if (((p_index_in_all_history+1)>=0) and
             ((p_index_in_all_history+amount_of_days+1)<self.all_history.size))  
            previous_chunk = Chunk.new(self.all_history.data[(p_index_in_all_history+1)..(p_index_in_all_history+amount_of_days+1)].reverse)
          end    
          points_with_chunks.push(Point.new(p.quote,previous_chunk,next_chunk))
        end
      end
    } 
    output = "AMOUNT OF QUOTES " + self.all_history.size.to_s + " <br> LAST QUOTE <br>" + last_quote.to_s + "<br>"
    output = output + "<b>RETRIEVED POINTS AND ITS PREVIOUS AND NEXT CHUNKS</b><br>"
    
    
  points_with_chunks = points_with_chunks.compact  
  if (format.eql? "html")
   points_with_chunks.each {|p|
      
      output = output + "<b>MY POINT</b><br>"  + p.to_html

     }      
  else
    if (format.eql? "json")
      output = points_with_chunks.inspect
    end
  end
  
  output = output + "<br><br> Forecasting for the next days <br><br>" + forecast_merge_avg(points_with_chunks).to_html()
  output
    

  end
  
    
  
  

    def find_object

    end

    def column_from_chunks(chunks,colnum)
      column=[]
      chunks.each {
        |current_chunk|
        column.push(current_chunk.data[colnum])
      }
      column
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


    def calculate_avg_for_chunks(chunks)
      current_trade_date = Date.today
      avg_chunk = []
      chunks[0].size.times {
        |i|
        q = Quote.new((current_trade_date + i).strftime("%Y-%m-%d").to_s,"0",calculate_avg_for_column(column_from_chunks(chunks,i)),"0","0","0","0","XXXX")
        avg_chunk.push(q)
      }
      Chunk.new(avg_chunk)

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