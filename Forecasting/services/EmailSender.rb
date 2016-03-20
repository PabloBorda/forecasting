require 'json'
require 'mail'


module Services


class EmailSender
  
  @instance
  
  
  def self.get_instance
    if @instance.nil?
      @instance = EmailSender.new
    end
    @instance    
  end
  
  
  def send_email(to,from,message)
    input = message
      
      Mail.deliver do
       from     'contact@localhost'
       to       'pablotomasborda@gmail.com'
       subject  'Contact from alphabrokers'
       html_part do
         content_type 'text/html; charset=UTF-8'
         body message.to_s
       end
      end
         
    true
      
    
    
  end
  
  
  private
  
  def initialize
  
  end

  
  
  
  
end

end