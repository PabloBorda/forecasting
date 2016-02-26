class GeneratedSocialNetworkController < ApplicationController

  protect_from_forgery:only=>[:create,:update,:destroy]

  @retrieved_list

  def load_index
    @retrieved_list = User.all
  end


  def print_network
  end



end
