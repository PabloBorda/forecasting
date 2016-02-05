require 'whenever'
require 'json'

module Maestro
  

  
  
job_type :god, 'god -c :configfile'
job_type :god_load_config, 'god :task :configfile'    
  




class Maestro
 
   
  @maestro
  @trading_hours
  @logger
  def self.get_instance
    if @maestro.nil?
      @maestro = Maestro.new    
    end
    @logger = Logger.new('logs/execution.log')
    @maestro    
  end
  
  
  
  def setup
    
    
    every 1.day, :at => '9:30 am' do
      trading_start = {:type => "trading_start"}
      @logger.info(trading_start) 
    end
    
    every 1.day, :at => '4:00 pm' do
      trading_finishes = {:type => "trading_finishes"}
      @logger.info(trading_start)
    end
     
      
    
    every 1.day, :at => '4:00 pm' do
      god :configfile => "scripts/accucheck.god"
    end
    
    
    
    
    
    every 1.day, :at => '4:00 pm' do
      @god_lambdas[:word_crawler].call
    end
    
 
    every 60.day, :at => '9:30 am' do
      god_load_config "load", :configfile => "scripts/batchforecasting.god"
    end
    
    
    
  end
  
  
  
  
end


end


maestro = Maestro::Maestro.get_instance()
maestro.setup






