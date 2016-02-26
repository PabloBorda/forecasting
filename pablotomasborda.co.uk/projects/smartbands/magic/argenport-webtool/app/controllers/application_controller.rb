# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'config/argenport_cfg.rb'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details


  

  def welcome

  end
  
  def login
    $users = [["Pablote.20@gmail.com","monoloco"],["matiasdisco@hotmail.com","matuteloco"],["elisabetkoenig@hotmail.com","mierda"],["susanadiber@gmail.com","susanadiber"],["claudiocarrizo82@hotmail.com","monochancho"]]
    if $users.include?([params['argenport-login'],params['argenport-pass']])
      session["user"] = params['argenport-login']
      redirect_to :controller => 'dashboard',:action => 'welcome'
    else
      redirect_to :action => 'wrong_user'
    end
    
  end
  
  def logout
    redirect_to :action => 'welcome'
  
  end
  
  def wrong_user
    
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
