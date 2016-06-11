# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever









job_type :god, 'god :task :configfile'

   every :weekday, :at => '0:00 am' do
     god "load",:configfile => Dir.pwd + "scripts/quotecrawler.god"
   end


    every :weekday, :at => '9:30 am' do
      runner "Task.trading_starts"
    end
    
    every :weekday, :at => '4:00 pm' do
      runner "Task.trading_stops"
    end
     
      
    
    every :weekday, :at => '4:00 pm' do
      god "-c",:configfile => Dir.pwd + "scripts/accucheck.god"
    end
    
    
    every :weekday, :at => '4:01 pm' do
      god "load",:configfile => Dir.pwd + "scripts/webnews.god"
    end
    

 
    every 60.day, :at => '9:30 am' do
      god "load", :configfile => Dir.pwd + "scripts/batchforecasting.god"
    end
    


