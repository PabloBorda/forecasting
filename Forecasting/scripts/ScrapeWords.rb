module Forecasting

  require 'json'

  require 'mongo'

  load 'Scraper.rb'

  class ScrapeWords

    result = {:Date => Time.now.strftime("%d/%m/%Y"), :Data =>[] }

    f = File.open("Files/symbols.txt", "r")
    f.each_line do |line|

      symbol=line.chomp.split('=')[0]

      #Create Scraper object for each symbol and go through CNN page
      scraper = Scraper.new(symbol)

      r = scraper.scrapeCNNPage()

      result[:Data].push(r)

    end

    db = Mongo::Client.new([ 'localhost:27017' ], :database => 'alphabrokers')

    db[:Scraper].insert_one(result)

    #puts result.to_json

  end

end