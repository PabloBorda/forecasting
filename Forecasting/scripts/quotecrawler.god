require 'logger'

@logger = Logger.new('../logs/quotecrawler.log')

  take_time_start = {:type => "process_start",:process_name => "QuoteCrawler", :start => Time.now }
   


God.watch do |w|
  w.name = "QuoteCrawler"
  w.dir = "/home/forecast/alphabrokers/Forecasting/scripts"
  w.start = "ruby quotecrawler.rb"
  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      take_time_finish = {:type => "process_finish",:process_name => "quotecrawler", :finish => Time.now }
      @logger.info(take_time_finish.to_json)      
      duration = {:type => "process_duration",:process_name => "quotecrawler", :finish => (Time.now - take_time_start[:start])}
      @logger.info(duration.to_json)    
    end
  end
  w.log = "../logs/quotecrawler.log"
  w.keepalive
end

