
#God.watch do |w|
#  w.name = "BatchForecasting"
#  w.dir = "/home/forecast/alphabrokers/Forecasting"
#  w.start = "ruby /home/forecast/alphabrokers/Forecasting/BatchForecasting.rb"
#  w.log = "batch.log"
#  w.keepalive
#end


God.watch do |w|
  w.name = "AccuCheck"
  w.dir = "/home/forecast/alphabrokers/Forecasting"
  w.start = "ruby /home/forecast/alphabrokers/Forecasting/accucheck.rb"
  w.log = "accucheck.log"
  w.keepalive
end
