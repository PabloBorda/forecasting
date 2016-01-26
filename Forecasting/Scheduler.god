
God.watch do |w|
  w.name = "BatchForecasting"
  w.dir = "/home/forecast/alphabrokers/Forecasting"
  w.start = "ruby /home/forecast/alphabrokers/Forecasting/BatchForecasting.rb"
  w.log = "batch.log"
  w.keepalive
end
