require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/assetpack'

get '/' do
  erb :dashboard
end