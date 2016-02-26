require 'sinatra'
require 'json'
require 'mail'



set :port, 82
set :bind, '0.0.0.0'

get '/contact*' do  
  input = params[:input]
  puts input.to_s
  Mail.deliver do
   from     'contact@www.pablotomasborda.co.uk'
   to       'pablotomasborda@gmail.com'
   subject  'Contact from www.pablotomasborda.co.uk'
   body     input.to_s
  end

  Mail.deliver do
   from     'pablotomasborda@gmail.com'
   to       input["email"]
   subject  'Contact from www.pablotomasborda.co.uk'
   body     "Hello Recruiter " + input["name"] + ", thank you so much for your email.\n I will reach you in the next couple of hours and answer your inquiries.\n" +
            "Let me know and we can coordinate an interview. I'm available on Skype, my username is: pablo.borda or hangouts at this email address. If for some reason\n" +
	    "you are behind a firewall, call my mobile +57-301-3599879.\n" + 
	    "REGARDS\n " + 
	    " Pablo Borda. "
            
  end
  
  "OK"
  
end
