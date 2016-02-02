require_relative '../model/MongoClient.rb'

class MongoTester

  @mongo
  def initialize
    @mongo = MongoClient.new
  end

end

mt = MongoTester.new