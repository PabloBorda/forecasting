load "YahooFinanceAPI.rb"


yahoo = YahooFinanceAPI.new
puts yahoo.get_all_us_symbols().inspect 