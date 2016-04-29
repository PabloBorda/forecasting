require 'aspector'




# Aspect used as a logging hookup
class TimingAspect < Aspector::Base
  ALL_METHODS = /.*/

  around ALL_METHODS, except: :class, method_arg: true do |method, proxy, *args, &block|
    class_method = "#{self.class}.#{method}"
    puts Time::now.to_s + "| Entering #{class_method}: #{args.join(',')}"
    before_time = Time::now
    result = proxy.call(*args, &block)
    after_time = Time::now - before_time
    timing_object = {:method_name => class_method, :duration => after_time}
    puts timing_object.to_json
    result
  end
end

