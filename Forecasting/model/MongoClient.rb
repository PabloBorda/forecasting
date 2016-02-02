require 'mongoid'

require_relative 'Point.rb'
require 'net/ssh/gateway'

class MongoClient
  def initialize
    @gateway = Net::SSH::Gateway.new('178.62.123.38', 'root', :password => 'alphabrokers')
    @gateway.open('178.62.123.38', 27017, 27018)
    Mongoid.load!("model/mongoid.yml", :production)

  end

end

