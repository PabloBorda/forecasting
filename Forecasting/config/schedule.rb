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


require 'logger'



@logger = Logger.new('logs/execution.log')


job_type :god, 'god -c :configfile'
job_type :god_load_config, 'god :task :configfile'



    every 1.day, :at => '9:30 am' do
      trading_start = {:type => "trading_start"}
      @logger.info(trading_start) 
    end
    
    every 1.day, :at => '4:00 pm' do
      trading_finishes = {:type => "trading_finishes"}
      @logger.info(trading_finishes)
    end
     
      
    
    every 1.day, :at => '4:00 pm' do
      god :configfile => "scripts/accucheck.god"
    end
    
    
    every 1.day, :at => '4:00 pm' do
      god :configfile => "scripts/webnews.god"
    end
    
    
    every 1.day, :at => '4:00 pm' do
     # @god_lambdas[:word_crawler].call
    end
    
 
    every 60.day, :at => '9:30 am' do
      god_load_config "load", :configfile => "scripts/batchforecasting.god"
    end
    


