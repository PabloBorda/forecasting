require 'logger'

@logger = Logger.new('logs/execution.log')



God.watch do |w|
  w.name = "AccuCheck"
  w.dir = "/home/forecast/alphabrokers/Forecasting"
  w.start = lambda {


    take_time_start = {:type => "process_start",:process_name => "batchforecasting", :start => Time.now }
    @logger.info(take_time.to_json)

    "ruby /home/forecast/alphabrokers/Forecasting/accucheck.rb"

  } 
  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      take_time_finish = {:type => "process_finish",:process_name => "accucheck", :finish => Time.now }
      @logger.info(take_time_finish.to_json)      
      duration = {:type => "process_duration",:process_name => "accucheck", :finish => (Time.now - take_time_start[:start])}
      @logger.info(duration.to_json)    
    end
  end
  w.log = "logs/batch.log"
  w.keepalive
end

