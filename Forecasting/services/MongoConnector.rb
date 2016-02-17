require 'date'
require 'json'
require 'rubygems'
require 'mongo'
require 'bson'
require 'net/ssh/gateway'
require 'logger'



module Services
  

  class MongoConnector
    @instance 
    @db
    
    def self.get_instance
      if @instance.nil?
        @instance = MongoConnector.new
      end
      @instance
    end
    
    
    def connect
      @db
    end
    
    
    
    private
    
    def initialize
      @gateway = Net::SSH::Gateway.new('178.62.123.38', 'root', :password => 'alphabrokers')
      
      @gateway.open('178.62.123.38', 27017, 27018)
  
      @db  = Mongo::Client.new([ 'localhost:27018' ], :database => 'alphabrokers')
  
      #puts "AMOUN QUOTES: " + @db.methods.inspect 
        
      
    end
  
  
  
  end



end