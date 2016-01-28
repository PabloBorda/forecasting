load 'Chunk.rb'
load 'Company.rb'
load 'Point.rb'
load 'Quote.rb'
load 'DrawSelector.rb'
load 'Forecaster.rb'
load 'AvgForecaster.rb'
load 'DeltaForecaster.rb'

require 'sinatra'
require 'json'

include Forecasting

set :bind,'0.0.0.0'
set :server,'webrick'
set :port, 9494

get '/' do

  out = ""
  
  company = Forecasting::Company.new("PYPL")
  
  
  avgf = Forecasting::Forecaster::AvgForecaster.new
  deltaf = Forecasting::Forecaster::DeltaForecaster.new
  
  
  
  "Average Algorithm <br>" +  avgf.forecast_on_me(company,60).to_html + "Delta Algorithm <br>" + deltaf.forecast_on_me(company,60).to_html
  
    
end
