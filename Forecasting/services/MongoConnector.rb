require 'date'
require 'json'
require 'rubygems'
require 'mongo'
require 'bson'
require 'net/ssh/gateway'
require 'logger'



module Services
  

  class MongoConnector
   
    
    @@instance = MongoConnector.new
    
    def self.get_instance
      return @@instance
    end
    
    
    def connect
      @db
    end
    
    
    
    private
    
    def initialize
      @gateway = Net::SSH::Gateway.new('178.62.123.38', 'root', :password => 'alphabrokers')
      
      @gateway.open('178.62.123.38', 27017, 27018)
  
      @db  ||= Mongo::Client.new([ 'localhost:27018' ], :database => 'alphabrokers')
  
      
      #puts "AMOUN QUOTES: " + @db.methods.inspect 
        
      
    end
  
    private_class_method :new
  
  end



end