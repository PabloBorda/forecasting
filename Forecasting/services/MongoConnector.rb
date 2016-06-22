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
    @connected = false
    
    def self.get_instance
      if @@instance.nil? 
        @@instance = MongoConnector.new
      end
      
      return @@instance
    end
    
    
    def connect
      if !connected?
        puts "INITIALIZE"

        @gateway = Net::SSH::Gateway.new('178.62.123.38', 'root', :password => 'alphabrokers')
      
        @gateway.open('178.62.123.38', 27017, 27018)
        @connected=true
        @db  ||= Mongo::Client.new([ 'localhost:27018' ], :database => 'alphabrokers')   
        @@instance = @db 
      else
        @db
      end

    end
    
    def connected?
      @connected
    end
    
    
    private_class_method :new
    
  
  
  end



end