require 'rubygems'


module Social

  class SocialNetwork
  
    def initialize(usr,pass)
      @usr = usr
      @pass = pass
      @graph = nil
    end
    
    def me
      raise NotImplementedError
    end
    
    def friends
      raise NotImplementedError
    end
    
    def login
      raise NotImplementedError
    end
    
    def logged?
      @graph.nil?
    end
    
    def logout
      raise NotImplementedError
    end
  
  end
  
  class Facebook < Social::SocialNetwork
  
    require 'koala'



    # Set an SSL certificate to avoid Net::HTTP errors
    Koala.http_service.http_options = {
      :ssl => { :ca_path => "/etc/ssl/certs" } 
    }


  
    def me
      @graph.get_object("me").to_json
    end
    
    def friends
      @graph.get_connections("me", "friends").to_json
    end
    
    def login

      @graph = Koala::Facebook::API.new("AAAEkHZB2ZBFNQBAOFbvZAiMJ8KB5PtwcF8phN4pU2QBVUPvtSrXPSkTUuVEDSTGXrBE4HSfmdLc2x4fLhpeKIZCVOD9Q4H1evLSZC7LUXiQZDZD")
    end
    
    def logout
      raise NotImplementedError
    end
  
  end  
  
  
  end




