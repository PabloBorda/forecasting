require 'logger'
require 'json'
require_relative '../services/EmailSender.rb'

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
     
      @email_service = ::Services::EmailSender.get_instance
      node_info = %x( ifconfig )
      text = "Process Finished <br> Process: QuoteCrawler <br> Start: " +
             take_time_start.to_json +
             "<br> Finish" +
             take_time_finish.to_json +
             "<br> Duration: " +
             duration.to_json + "<br>" + 
             "Node Information: " + 
             node_info
     @email_service.send_email("pablotomasborda@gmail.com","process_notification@localhost",text)
    end

    on.condition(:process_running) do |c|
      @email_service = ::Services::EmailSender.get_instance
      node_info = %x( ifconfig )
      text = "<b>Process Started</b> <br> <b>Process: QuoteCrawler</b> <br> Start: " +
             take_time_start.to_json + "<br>" +
             "Node Information: <br>" +
             node_info
      @email_service.send_email("pablotomasborda@gmail.com","process_notification@localhost",text)
      c.interval = 30.seconds
      c.running = false 
    end



  end
  w.log = "../logs/quotecrawler.log"
#  w.keepalive
end

