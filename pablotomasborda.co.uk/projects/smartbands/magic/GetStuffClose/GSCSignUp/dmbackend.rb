require 'rubygems'
require 'sinatra'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'net/http'
require 'uri'


  #use Rack::Auth::Basic, "Restricted Area" do |username, password|
  #  [username, password] == ['admin', 'admin']
  #end
  

  set :port, 80
 
  get '/' do
    erb :index
  end

  get '/login' do
    erb :index
  end

  get '/pay' do
     card_object = ActiveMerchant::Billing::CreditCard.new(
      :number     => params[:number],
      :month      => params[:month],
      :year       => params[:year],
      :first_name => params[:first_name],
      :last_name  => params[:last_name],
      :verification_value =>params[:verification_value]
      )
      
      card_to_log = Card.new(:cardnumber => params[:number], :expmonth => params[:month],:expyear => params[:year],:firstname => params[:first_name],:lastname => params[:last_name] )
    
      card_to_log.save

      transaction = Transaction.new
      transaction.user_id =  @current_user.id
      transaction.card_id = card_to_log.id
      transaction.amount = Float(session[:amount_to_pay])
           
      
      
      session[:first_name] = params[:first_name]
      session[:last_name] = params[:last_name]
     
    
      if !card_object.valid?
        redirect_to :action => "wrong_card"
      else        
        payer = PaymentHelper::PaypalPayer.new
        payment = PaymentHelper::Payment.new(payer)
        amount = Integer(session[:amount_to_pay])
        response = payment.pay(amount,card_object)
        
        puts response
        
        if response.include? "Success"
            transaction.success = true
            NotificationMailer.deliver_payment_receipt(session[:amount_to_pay],@current_user.email)
          @respondent = (find_cart.get_product(1)).user
            NotificationMailer.deliver_invite_respondent(@current_user,@respondent)

          
        else
            transaction.success = false
        end
        transaction.case_id = session[:caseid]
        transaction.save
      end  
  end #get/pay
  
  @path_to_picture
  @path_to_picture_html
  
  get '/upload' do
    got_it = params['company-logo']
    company_name = params['company-name'].delete " "
    if !File.directory? 'public/images/' + company_name
      Dir.mkdir('public/images/' + company_name)
    end
    @path_to_picture = 'public/images/' + company_name + '/' + got_it.original_filename
    File.open(@path_to_picture, "wb") { |f| f.write(got_it.read) }
    @path_to_picture_html = 'images/' + company_name + '/' + got_it.original_filename
        
  end
  
  get '/geolocation/addresses*' do
    addr = params[:addr]
    puts '---------------http://maps.googleapis.com/maps/api/geocode/json?address=' + addr.gsub(' ','%20') + '&sensor=false'
    uri = URI.parse 'http://maps.googleapis.com/maps/api/geocode/json?address=' + addr.gsub(' ','%20') + '&sensor=false'     
    @res = Net::HTTP.get_response(uri).body
    erb :addresses
  end
  
  get '/storetable' do
    erb :storetable
    
  end
  
   get '/productstable' do
    erb :productstable
    
  end
  
  
  get '/captcha' do
    uri = URI.parse 'http://www.papitomarket.com:81/captcha'
    @res1 = Net::HTTP.get_response(uri).body
    erb :captcha
   
  end
  
  get '/test/:str' do
    uri = URI.parse('http://soa1.papitomarket.com:9494/test/' + params[:str].delete(" "))
    @res1 = Net::HTTP.get_response(uri).body
    erb :captcha    
  end
  
  post '/newcompanyws' do
    puts "This is the json "  + params[:json].to_s
    @newcompany_output = Net::HTTP.post_form(URI.parse('http://soa1.papitomarket.com:9494/newcompany'),params[:json])
    puts @newcompany_output.to_s
  end