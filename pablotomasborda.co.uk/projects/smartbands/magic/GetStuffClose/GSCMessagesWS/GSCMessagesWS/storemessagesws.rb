# Run this before running the web service
#  export DATABASE_URL=mysql://root:justice@soa1.getstuffclose.com:3306/storemessages
# To grant access: GRANT ALL ON storemessages.* TO root@'getstuffclose.com' IDENTIFIED BY 'justice';

require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'sinatra/activerecord'
require 'json'
require 'sinatra/activerecord'

set :database, 'mysql://root:justice@soa1.getstuffclose.com:3306/storemessages'

class Message < ActiveRecord::Base
  belongs_to :address    
end


class Address < ActiveRecord::Base
  has_many :messages
end




class MessagesWS < Sinatra::Base

  #set :sessions, true
  #set :foo, 'bar'
  get '/' do
    "Hello World"
  end
  
  get '/messages/:addr' do
    @address = params[:addr]
    @address_id = Address.find_by_address(@address)
    puts "I found the address " + @address_id.to_s
    @messages = Message.find_all_by_address_id(@address_id.id)
    #@messages.to_s
    erb :messages
  end
  
  post '/messages' do
    @address = params[:addr]
    @address_id = Address.find_by_address(@address)
    if !@address_id.nil?
      puts "I found the address " + @address_id.to_s
      @messages = Message.find_all_by_address_id(@address_id.id)
      #@messages.to_s
      erb :messages
    else
      "0"
    end
  end
  
end


MessagesWS.run! :host => 'localhost', :port => 9191