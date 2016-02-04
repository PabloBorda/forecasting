require 'god'
require 'whenever'


module Maestro
  


@god_lambdas = {
  
  :accucheck => Proc.new {
    God.watch do |w|
      w.name = "BatchForecasting"
      w.dir = "/home/forecast/alphabrokers/Forecasting"
      w.start = "ruby /home/forecast/alphabrokers/Forecasting/BatchForecasting.rb"
      w.log = "batch.log"
      w.keepalive
    end
    
    
  },
    
  :batch_forecasting => Proc.new {
    God.watch do |w|
      w.name = "AccuCheck"
      w.dir = "/home/forecast/alphabrokers/Forecasting"
      w.start = "ruby /home/forecast/alphabrokers/Forecasting/accucheck.rb"
      w.log = "accucheck.log"
      w.keepalive
    end    
  },
  :word_crawler => Proc.new {
    
    every 1.day, :at => '0:00 am' do
      runner "ruby scripts/"
    end
    
    
    
    
  }
  
  
  
  
}





class Maestro
 
   
  @maestro
  def self.get_instance
    if @maestro.nil?
      @maestro = Maestro.new    
    end
    @maestro    
  end
  
  
  def start
    
    
    
    
  end
  
  
 private
 
  

 
  
  
  
  
  
  
end


end


maestro = Maestro::Maestro.get_instance()
maestro.start()






