#!/usr/bin/env ruby
require 'rubygems'

require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'koala'

require 'webrick'
require 'webrick/https'
require 'openssl'


# Set an SSL certificate to avoid Net::HTTP errors
Koala.http_service.http_options = {
  :ssl => { :ca_path => "/etc/ssl/certs" }
}


CERT_PATH = '/opt/myCA/server/'
 
webrick_options = {
        :Port               => 4567,
        :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
        :DocumentRoot       => "/ruby/htdocs",
        :SSLEnable          => true,
        :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "my-server.crt")).read),
        :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "my-server.key")).read),
        :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}


class IWantToSendFB < Sinatra::Base


  before do
  
#    @oauth = Koala::Facebook::OAuth.new("321194527954132","3afcc0c7f64805bb7cfb07fac38cd92b","http://getstuffclose.com:4567/")
    
    @graph = Koala::Facebook::API.new("AAAEkHZB2ZBFNQBAJBbb6SoPn2SWZBn4SNNuyqoxcQZADvo8Xt6LCVMi7d1ATu2V94XU8OW9DpLpVNXWix2ZAPcGoZBIYp7aQrD4ysJpHaLAwZDZD")
  
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

Rack::Handler::WEBrick.run IWantToSendFB, webrick_options
