module Forecasting
  
  require 'gruff'
  
  
  class LineChart
    
    g = Gruff::Line.new(200)
        g.title = 'Very Small Line Chart 200px'
        g.labels = @labels
        @datasets.each do |data|
          g.data(data[0], data[1])
        end
        g.write('test/output/line_very_small.png')
    
  end
  
end