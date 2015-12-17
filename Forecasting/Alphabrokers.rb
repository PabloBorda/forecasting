load 'Chunk.rb'
load 'Company.rb'
load 'Point.rb'
load 'Quote.rb'

require 'sinatra'
require 'json'

include Forecasting

set :bind,'0.0.0.0'
set :server,'webrick'
set :port, 9494

get '/' do


  Company.new("AAPL").forecast_html(20)
#"HELLO WORLD!"
  #Company.new("AAPL").all_history.each do |q| o = o + q.inspect.to_s end
    
end
