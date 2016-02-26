require 'rubygems'
require 'sinatra'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'net/http'
require 'uri'
require 'json'
require 'langs'
require 'public/sp_res'
require 'public/en_res'
require 'public/fr_res'
require 'public/it_res'






  #use Rack::Auth::Basic, "Restricted Area" do |username, password|
  #  [username, password] == ['admin', 'admin']
  #end
  

  set :port, 8080
  
  
  
  get '/ccxml_wrapper.xml*' do
    @locale = params[:locale].to_s
    erb :ccxml_wrapper    
  end
  
  
  
  get '/smartbands.xml*' do
    locale = params[:locale].to_s
    @msgs = (Locale::Texts.new).send(locale)

    @sample_json = "{ \"type\": \"SBSoldNotification\",\"body\": { \"name\": \"Pablo Borda\",\"user\": \"Pablo Tomas Borda\",\"addr\": \"Avenida Corrientes 3722, Buenos Aires, Autonomous City of Buenos Aires, Argentina\",\"items\": [{ \"category\" : \"Empanadas\", \"products\" : [ {\"name\": \"Carne Suave\",\"amount\": \"6\",\"price\": \"4\"},{\"name\": \"Carne Picante\",\"amount\": \"9\",\"price\": \"5\"},{\"name\": \"Carne Saltena\",\"amount\": \"4\",\"price\": \"6\"}],\"total\": \"85,5\",\"payswith\": \"100\"}]}}" 


    parsed_order = JSON.parse(@sample_json)
    @ddr = ""
    @currency = @msgs[:currency].to_s
    @user = parsed_order["body"]["user"].to_s
    if (parsed_order["type"].to_s.eql? "SBSoldNotification")
      @addr = parsed_order["body"]["addr"].to_s
      @products = "" 
      count = 1
      parsed_order["body"]["items"].each do |c|
        @products = @products + "<prompt xml:lang=\"" + @msgs[:prompt_extension].to_s + "\"> " + @msgs[:categories_intro].to_s + c["category"].to_s + ".</prompt>"
        c["products"].each do |p|
          @products = @products + "<prompt xml:lang=\"" + @msgs[:prompt_extension].to_s + "\"> " + @msgs[:product_item].to_s  + count.to_s  + ".</prompt>" + " <prompt xml:lang=\"" + @msgs[:prompt_extension].to_s + "\"> " + p["name"] + ".</prompt>" + "<prompt xml:lang=\"" + @msgs[:prompt_extension].to_s + "\">" + @msgs[:price].to_s + p["price"].to_s + " " + @currency.to_s + ".</prompt>"  + "<prompt xml:lang=\"" + @msgs[:prompt_extension].to_s + "\"> " + @msgs[:amount].to_s + p["amount"] + @msgs[:units].to_s + ".</prompt>"
         count = count + 1
        end
      end
       
      @pays_with = "<prompt xml:lang=\"" + @msgs[:prompt_extension].to_s + "\"> " + @msgs[:user_expectation].to_s + " " + parsed_order["body"]["payswith"].to_s + " " + @msgs[:currency].to_s + "</prompt>"
      erb :index
      

    else
      "<prompt>This order has an error while parsing json, please correct it.</prompt>"
    end   
  end
 
  get '/1' do
    erb :menuPago
  end

