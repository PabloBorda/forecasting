require 'aspector'
require_relative '../MongoConnector.rb'




# Aspect used as a logging hookup
class TimingAspect < Aspector::Base
  ALL_METHODS = /.*/
  
  mongo = ::services::MongoConnector.new
  
  around ALL_METHODS, except: :class, method_arg: true do |method, proxy, *args, &block|
    class_method = "#{self.class}.#{method}"
    puts Time::now.to_s + "| Entering #{class_method}: #{args.join(',')}"
    before_time = Time::now
    result = proxy.call(*args, &block)
    after_time = Time::now - before_time
    timing_object = {:class_name => "#{self.class}",:method_name => class_method, :duration => after_time}
    puts timing_object.to_json
    mongo[:timing].insert_one(timing_object.to_json) 
    result
  end
end

