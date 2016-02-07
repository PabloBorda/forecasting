require_relative '../model/Company.rb'
require_relative '../model/Chunk.rb'

require 'date'
require 'json'
require 'rubygems'
require 'mongo'
require 'bson'
require 'net/ssh/gateway'
require 'logger'

include Forecasting

class Accucheck

  include Mongo

  @db
  @gateway
  @last_symbol
  def initialize
    @logger = Logger.new('logs/execution.log')
    @logger.info(take_time_start.to_json)
    
    @gateway = Net::SSH::Gateway.new('178.62.123.38', 'root', :password => 'alphabrokers')
    @gateway.open('178.62.123.38', 27017, 27018)

    @db  = Mongo::Client.new([ 'localhost:27018' ], :database => 'alphabrokers')

    puts @db['alphabrokers'].find({}).limit(1).to_a.to_json
  end

  def accuracy_per_algorithm_per_company

  end

  def accuracy_global
    count = @db[:Accuchecks].count()

    pages = (count/10).round

    page_size = 10

    close_difference_sum = 0

    pages.times.each do |i|
      @db[:Accuchecks].find({}).skip(i*page_size).limit(page_size).to_a.each do |f|
        f_parsed = JSON.parse(f.to_json)
        close_difference_sum = close_difference_sum + f_parsed['difference']['close'].to_f
        #puts f_parsed['symbol']
        #accuracy_by_company_and_algorithm = {'symbol' => f_parsed['symbol'] }
        #@db[:Accuchecks].find({'symbol' => f_parsed['symbol']}).each do
        #  |ac|
        #  if accuracy_by_company_and_algorithm[f_parsed['algorithm']].nil?
        #    accuracy_by_company_and_algorithm[f_parsed['algorithm']] = 0
        #  else
        #    accuracy_by_company_and_algorithm[f_parsed['algorithm']] = accuracy_by_company_and_algorithm[f_parsed['algorithm']] + f_parsed['difference']['close'].to_f
        #  end

        #end

        #puts f_parsed['algorithm']

        #end
      end

    end

    puts "THE AVERAGE ERROR IS: " + (close_difference_sum/count).to_s

  end

  def run

    count = @db[:Forecasts].count()

    insertion_counter = 0

    pages = (count/10).round

    page_size = 10

    pages.times.each do |i|
      @db[:Forecasts].find({}).skip(i*page_size).limit(page_size).to_a.each do |f|
        f_parsed = JSON.parse(f.to_json)     # convert BSON to_json and then parse the JSON into a plain ruby object
        f_last_quote = last_quote_from_symbol(f_parsed['symbol'])

        if !f_last_quote.nil? and f_last_quote.close>0

          puts "Accucheck company " + f_parsed['symbol']

          f_parsed['forecasts'].each do |forecast|
            puts "AccuCheck for: " + forecast['algorithm_name']

            if @db[:Accuchecks].find({:symbol => f_parsed['symbol'],:date => f_last_quote.trade_date, :algorithm => forecast['algorithm_name'] }).to_a.size == 0
              puts "NO EXISTING RECORD"
              pivot_quote_trade_date = forecast['forecast']['quote']['trade_date']
              left_chunk_from_forecast_to_check = forecast['forecast'][' previous_n_quotes_chunk']
              right_chunk_from_forecast_to_check = forecast['forecast'][' next_n_quotes_chunk']
              #puts "RIGHT: " + forecast['forecast'][' next_n_quotes_chunk'].inspect
              if !right_chunk_from_forecast_to_check.nil?
                forecasted_quote = right_chunk_from_forecast_to_check.find do
                  |q|
                  (q['trade_date'] == f_last_quote.trade_date)
                end
                if !forecasted_quote.nil? and forecasted_quote['close'].to_f>0

                  puts "forecasted_quote: " + forecasted_quote.inspect
                  puts "real quote value: " + f_last_quote.inspect

                  difference = class_from_string(forecast['algorithm_name']).accucheck_me(Quote.from_openstruct(f_last_quote),Quote.from_openstruct(forecasted_quote))

                  if !difference.nil?

                    accuracy_row = { :symbol => f_parsed['symbol'],
                      :algorithm => forecast['algorithm_name'],
                      :date => f_last_quote.trade_date,
                      :real_quote => Quote.from_openstruct(f_last_quote).to_hash,
                      :forecasted_quote => Quote.from_openstruct(forecasted_quote).to_hash,
                      :difference => difference.to_hash
                    }

                    #puts accuracy_row.to_json

                    puts "INSERTING: " + accuracy_row.inspect
                    @db[:Accuchecks].insert_one(accuracy_row)  # Here should go the mongo insert
                    insertion_counter = insertion_counter + 1

                  end
                else
                  puts "FORECASTED_QUOTE_NOT_FOUND!"
                end

              end
            end

          end
        end
      end
    end

  end

  private

  def last_quote_from_symbol(symbol)
    c = Company.new(symbol)
    #puts "FIRST HISTORY" + (c.last_quote).to_j
    return c.last_quote

  end

  def class_from_string(str)
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end

end

ac = Accucheck.new
ac.run
ac.accuracy_global

