require 'aspector'




# Aspect used as a logging hookup
class TimingAspect < Aspector::Base
  ALL_METHODS = /.*/

  around ALL_METHODS, except: :class, method_arg: true do |method, proxy, *args, &block|
    class_method = "#{self.class}.#{method}"
    #puts "Entering #{class_method}: #{args.join(',')}"
    before_time = Time::now
    result = proxy.call(*args, &block)
    after_time = Time::now - before_time
    puts "Benchmark  #{class_method}: took #{after_time} seconds..."
    result
  end
end

