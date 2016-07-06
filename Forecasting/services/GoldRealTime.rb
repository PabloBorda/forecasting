require 'singleton'
require 'yahoo-finance'
require 'uri'
require 'net/http'


class GoldRealTime
  
  include Singleton
  
  
  #  curl "http://www.24hgold.com/english/gold_silver_prices_charts.aspx/GetLastValue?sCurrency=USD" -H "Content-Type: application/json; charset=utf-8"
  def real_time_quote
    size = 1000 #the last offset (for the range header)
    uri = URI("http://www.24hgold.com/english/gold_silver_prices_charts.aspx/GetLastValue?sCurrency=USD")
    http = Net::HTTP.new(uri.host, uri.port)
    headers = {
        'Content-Type' => 'application/json',
        'charset' => 'utf-8'
    }
    path = uri.path.empty? ? "/" : uri.path
    
    #test to ensure that the request will be valid - first get the head
    code = http.head(path, headers).code.to_i
    if (code >= 200 && code < 300) then
    
        #the data is available...
        http.get(uri.path, headers) do |chunk|
            #provided the data is good, print it...
            print chunk unless chunk =~ />416.+Range/
        end
    end

  end
  
  
  
end



gold_service = GoldRealTime.instance
puts "IGOT: " + gold_service.real_time_quote