require 'logger'
require 'json'
require_relative '../services/EmailSender.rb'

@logger = Logger.new('../logs/accucheck.log')

  take_time_start = {:type => "process_start",:process_name => "accucheck", :start => Time.now }
   


God.watch do |w|
  w.name = "AccuCheck"
  w.dir = "/home/forecast/alphabrokers/Forecasting/scripts"
  w.start = "ruby accucheck.rb"
  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      take_time_finish = {:type => "process_finish",:process_name => "accucheck", :finish => Time.now }
      @logger.info(take_time_finish.to_json)      
      duration = {:type => "process_duration",:process_name => "accucheck", :finish => (Time.now - take_time_start[:start])}
      @logger.info(duration.to_json)    
      @email_service = ::Services::EmailSender.get_instance
      node_info = %x( ifconfig )
      text = "Process Finished <br> Process: AccuCheck <br> Start: " +
             take_time_start.to_json +
             "<br> Finish" +
             take_time_finish.json +
             "<br> Duration: " +
             duration.to_json + 
             "Node Information: " + 
             node_info
     @email_sender.send_email("pablotomasborda@gmail.com","process_notification@localhost",text)
    end
  end
  w.log = "../logs/accucheck.log"
  w.keepalive
end

