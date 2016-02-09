require_relative '../services/QuoteCrawler.rb'

include Forecasting::QuoteData

@crawler = QuoteCrawler.get_instance

@crawler.crawl