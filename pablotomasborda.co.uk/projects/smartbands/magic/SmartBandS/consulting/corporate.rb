require 'rubygems'
require 'sinatra'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'net/http'
require 'uri'


  set :port, 80
 
  get '/' do
    erb :index
  end
  
  get '/one' do
    erb :one 
  end
  
  get '/two' do
    erb :two
  end
  
  get '/three' do
    erb :three
  end

    
  
  get '/captcha' do
    uri = URI.parse 'http://papitomarket.com:81/captcha'
    @res1 = Net::HTTP.get_response(uri).body
    erb :captcha
   
  end
  
  
  def filter_shit_from_emails(email)
    return email.gsub('@','_').gsub('.','-')
  end
  
  post '/upload' do
    puts "Uploading file..."
    if !(Dir.exist? 'public/files/' + filter_shit_from_emails(params[:email]))
      Dir.mkdir('public/files/' + filter_shit_from_emails(params[:email]))
    end
    File.open('public/files/' + filter_shit_from_emails(params[:email]) + '/' + params[:doc][:filename], "w") do |f|
      f.write(params[:doc][:tempfile].read)
    end
    
    File.open('public/files/' + filter_shit_from_emails(params[:email]) + '/' + params[:name].gsub(' ','') + '.txt','a') do |f|
      f.puts params[:name].to_s + "\n" + filter_shit_from_emails(params[:email]) + "\n" + params[:message].to_s
    end
    
    puts params[:name]
    puts params[:email]
    puts params[:message]
    puts "Upload complete"
    redirect '/three'
  end
  
