#require 'net/ssh'




# All platform components, addresses, and configurations go here
servers = [{:server_type => 'soa',
                 :addr => 'soa1.getstuffclose.com',
                 :port => '9494',
                 :ssh_usr => 'root',
                 :ssh_pass => 'p0tat0l0c0',
                 :db_url => 'mysql://root:justice@soa1.getstuffclose.com:3306/delivery'          
               },
               {:server_type => 'picrepo',
                 :addr => 'soa1.getstuffclose.com',
                 :port => '9494',
                 :ssh_usr => 'root',
                 :ssh_pass => 'p0tat0l0c0'
               },
               {:server_type => 'chat'
               
               },
               {:server_type => 'webfrontend'},
               {:server_type => 'messages'}]

=begin

def deploy


end    
    
    
          

ARGV.each do|a|
  if a.to_s.eql? "install"
    
  else if a.to_s.eql? "run"
  
       end
  end
end                                            


=end


