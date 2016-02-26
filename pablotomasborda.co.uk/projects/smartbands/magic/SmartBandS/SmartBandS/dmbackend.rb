require 'rubygems'
require 'sinatra'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'net/http'
require 'uri'
require 'json'


  set :port, 4568
 
  get '/' do
    erb :index
  end

  get '/superproducts' do
    addr = params[:search]
    puts addr
    url = URI.parse('http://soa1.papitomarket.com:9494/superproducts?term=' + addr.to_s)
    puts 'Direccion WEB = ' + url.to_s
    @res = JSON.parse(Net::HTTP.get_response(url).body.to_s)
    puts '@res  ' + @res.to_s 
    @res.to_json
  end
