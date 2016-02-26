#!/usr/bin/env ruby
require 'rubygems'

require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'koala'


# Set an SSL certificate to avoid Net::HTTP errors
Koala.http_service.http_options = {
  :ssl => { :ca_path => "/etc/ssl/certs" }
}



class IWantToSendFB < Sinatra::Base


  before do
  
#    @oauth = Koala::Facebook::OAuth.new("321194527954132","3afcc0c7f64805bb7cfb07fac38cd92b","http://getstuffclose.com:4567/")
    
    @graph = Koala::Facebook::API.new("AAAEkHZB2ZBFNQBAO0RMU9iowDA5m6QAvl7FCAhqQKTdPtZBJRig4zb7PZAoue5LQd3fSfcg0aieCKTJhFWc1yEZBvKCfK9JOyHt5ZB9cIkIAZDZD")
  
  end


  get '/friends' do
    friends = @graph.get_connections("me", "friends")
    friends.to_json    
  end


  get '/me' do
  
#    @oauth = Koala::Facebook::OAuth.new("321194527954132","3afcc0c7f64805bb7cfb07fac38cd92b","http://getstuffclose.com:4567/")
  
    # in 1.1 or earlier, use GraphAPI instead of API

    profile = @graph.get_object("me")
    profile.to_json
    #@graph.put_connections("me", "feed", :message => "I am writing on my wall!")
  end

  get '/' do
    @user = @graph.get_object("me")
    erb :index
  end

end


IWantToSendFB.run! :host => 'localhost', :port => 4567