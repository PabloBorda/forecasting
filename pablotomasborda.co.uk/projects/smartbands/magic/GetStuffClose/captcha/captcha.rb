require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/assetpack'
require 'sinatra/ratpack'
require 'net/http'
require 'uri'
require 'RMagick'

class String
  
  
  def encript
    @convertiontable = Hash["a","1","b","2","c","3","d","4","e","5","f","6","g","7","h","8","i","9","j","0","k","q","l","w","m","e","n","r","o","t","p","y","q","u","r","i","s","o","t","p","u","a","v","s","w","d","x","f","y","g","z","h"]
    res = ""
    
    self.each_char do |c|
      usechar = ""
      if @convertiontable[c].nil?
	usechar = c
      else
	usechar = @convertiontable[c]
      end
      res = res + usechar
     
    end
    res
  end
  
  def decript
    @convertiontable1 = Hash["a","1","b","2","c","3","d","4","e","5","f","6","g","7","h","8","i","9","j","0","k","q","l","w","m","e","n","r","o","t","p","y","q","u","r","i","s","o","t","p","u","a","v","s","w","d","x","f","y","g","z","h"]

    convertiontableinverse = @convertiontable1.invert
    puts convertiontableinverse
    res = ""
    
    self.each_char do |c|
      usechar = ""
      if convertiontableinverse[c].nil?
	usechar = c
      else
	usechar = convertiontableinverse[c]
      end
      res = res + usechar
     
    end
    res
    
  end
  
end



module Captcha

include Magick






class Captcha
  
  
  def initialize

  end
  
  
  
  @public
  
  def generate
    
    words = self.get_random_words
    # Create a 100x100 red image.
    f = Magick::Image.new(220,90) { 
      r = Random.new.rand(0...255)
      g = Random.new.rand(0...255)
      b = Random.new.rand(0...255)
      self.background_color = "rgb(" + r.to_s + "," + g.to_s + "," + b.to_s + ")" }
    textpic = Magick::Draw.new
    textpic.bezier(20,180, 20,30, 320,330, 320,180)
    textpic.annotate(f, 0,0,0,40, words[0] + " " + words[1]) {
      self.font_family = 'Helvetica'
      self.fill = 'white'
      self.stroke = 'transparent'
      self.pointsize = 32
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::NorthGravity
    }
    @im = "public/images/" + (words[0] + words[1]).encript + ".png"
    
    r = Random.new
    n = r.rand(0...10)
    
    case n
      when 0..3
        f.spread(2).radial_blur(15).write(@im)
      when 2..6
        f.radial_blur(15).write(@im)
      when 6..8
        f.radial_blur(15).solarize.write(@im)
       when 8..10
        f.spread(2).write(@im)
    end

    
    
    
    
    
    
    @im
  end
  

  
  @private
  
  def filter(word)
    word.delete("'").delete("!").delete(";").delete(".").delete(",").delete("-").delete("?").delete("_").delete(":").delete("\"").delete("*").delete("(").delete(")")
    
  end
  
  def get_random_words
    file = File.open "alice.txt"
    contents = ""
    file.each {|line|
      contents << line
    }
    words = contents.split(" ")
    
    
    
    r = Random.new
    while ( (@w1.nil? or @w2.nil?) or ((@w1.size + @w2.size)>=11)) do
      n1 = r.rand (0...words.size)
      n2 = r.rand (0...words.size)
    
      @w1 = filter(words[n1])
      @w2 = filter(words[n2])
    end
    
    puts @w1
    puts @w2
    puts @w1.decript
    puts @w2.decript
    
    
    [@w1,@w2]
    
    
  end
  
  
  
  
  
end

end

set :port, 81

get '/' do
  erb :index
end
  
  
get '/captcha' do
  c = Captcha::Captcha.new
  @impath = c.generate
  @impath = "http://getstuffclose.com:81/" + @impath.sub!("public/","")
  erb :captcha
end

get '/test/:str' do

  if FileTest.exists?("public/images/" + params[:str].delete(" ").encript + ".png")
    File.delete("public/images/" + params[:str].delete(" ").encript + ".png")
    "<img src=\"http://getstuffclose.com:81/images/success.png\"/>" 
   
  else
   "<img src=\"http://getstuffclose.com:81/images/failed.png\"/>"
  end


  
end




#WebCaptcha.run