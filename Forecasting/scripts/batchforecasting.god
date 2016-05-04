require 'logger'
require 'json'
require_relative '../services/EmailSender.rb'

@logger = Logger.new('../logs/batchforecasting.log')

  take_time_start = {:type => "process_start",:process_name => "QuoteCrawler", :start => Time.now }
   


God.watch do |w|
  w.name = "BatchForecasting"
  w.dir = "/home/forecast/alphabrokers/Forecasting/scripts"
  w.start = "ruby BatchForecasting.rb"
  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      take_time_finish = {:type => "process_finish",:process_name => "batchforecasting", :finish => Time.now }
      @logger.info(take_time_finish.to_json)      
      duration = {:type => "process_duration",:process_name => "batchforecasting", :finish => (Time.now - take_time_start[:start])}
      @logger.info(duration.to_json)    
     
      @email_service = ::Services::EmailSender.get_instance
      node_info = %x( ifconfig )
      log_tail = %x( tail -n 200 ../logs/batchforecasting.log )

      text = "<b>Process Finished</b> <br> Process: BatchForecasting <br> Start: " +
             take_time_start.to_json + "<br>" +
             "<br> Finish" + "<br>" + 
             take_time_finish.to_json + "<br>" +
             "<br> Duration: <br>" +
             duration.to_json + "<br>" + 
             "Node Information: <br>" + 
             node_info + "<br><br>" +
             "<b>Last trace lines</b><br><br>" + 
             log_tail 
             
     @email_service.send_email("pablotomasborda@gmail.com","process_notification@localhost",text)
    end
    on.condition(:process_running) do |c|
      @email_service = ::Services::EmailSender.get_instance
      node_info = %x( ifconfig )
      text = "<b>Process Started</b> <br> <b>Process: BatchForecasting</b> <br> Start: " +
             take_time_start.to_json + "<br>" +
             "Node Information: <br>" +
             node_info
      @email_service.send_email("pablotomasborda@gmail.com","process_notification@localhost",text)
    end
  end
  w.log = "../logs/batchforecasting.log"
#  w.keepalive
end

