module Forecasting
  
  require 'mechanize'
  require 'nokogiri'
  require 'open-uri'
  require 'open_uri_redirections'
  require 'json'
  
  class Scraper
    
    def initialize(symbol)       
          # Create CNN news URL based on symbol
          @symbol = symbol
          @url = 'http://money.cnn.com/quote/news/news.html?symb=' + @symbol 
          
          # Initialize positive/negative words array based on external txt file
          @positiveWordsArray = Array[]
          @negativeWordsArray = Array[]
            
          f = File.open("Files/positive.txt", "r")        
          f.each_line do |line|
            @positiveWordsArray.push(line.chomp)     
          end
          f.close
         
          f2 = File.open("Files/negative.txt", "r")       
          f2.each_line do |line|
            @negativeWordsArray.push(line.chomp)         
          end  
          f2.close     
          
          f3 = File.open("Files/symbols.txt", "r")         
          @symbolName = ""
          f3.each_line do |line|
            if line.chomp.include? @symbol          
               @symbolName=line.chomp.split('=')[1]
               puts @symbolName
               break
            end
          end
          f3.close
     end
     
     
     # Method to return the list of positive words
     def getPositiveWordsArray   
       return @positiveWordsArray   
     end
     
     
     # Method to return the list of negative words
     def getNegativeWordsArray    
       return @negativeWordsArray 
     end
     
     
     # Method to return a count of negative and positive words
     def scrapeCNNPage
       # Create mechanize object and obtain CNN news page
       mechanize = Mechanize.new 
       mechanize.user_agent_alias = "Windows Mozilla"
       page = mechanize.get(@url)  
       
       # Store the different news links from the page in an Array
       arrayLinks = Array[]
       page.links_with(:class => 'wsod_bold').each do |link|
          arrayLinks.push(link)
       end
       
       # Counters for positive and negative words
       
       positiveCounter = 0
       negativeCounter = 0
      
       # Iterate each link and call countWords for each
       arrayLinks.each do |link| 
         
         puts link.href
         #if !link.href.include?("www.ft.com") 
           
            result = countWords(link.href)
            
            positiveCounter = positiveCounter + result[:Positive]
            negativeCounter = negativeCounter + result[:Negative]
            
         #end
         
       end
       
       return { :Positive => positiveCounter, :Negative => negativeCounter, :Symbol => @symbol, :Date => Time.now.strftime("%d/%m/%Y")}
       
     end
     
     # Method to count the positive/negative words found in an HTML page related to the financial symbol
     
     def countWords(href)
       
       # Use mechanize to follow link and get contents
       mechanize = Mechanize.new 
       mechanize.user_agent_alias = "Windows Mozilla"
       mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
       mechanize.redirect_ok = true
       
       page = mechanize.get(href) 
 
       # Use Nokogiri to get the HTML content of a link.
       # html_doc = Nokogiri::HTML(open(href,:allow_redirections => :all, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
       
       html_doc = Nokogiri::HTML(page.content)
         
       # Look for all <p> tags and store their contents
       paragraph = html_doc.css("p").inner_text
       
       # Split the content in single sentences and store in array           
       strings = Array[]
       strings = paragraph.split('.')
                    
       #Counters for positive and negative words
       positiveCounter = 0
       negativeCounter = 0
       
       # Iterate the sentence array
       strings.each do |s|
         
         # If the sentence includes the @symbol or the @symbolName, split in single words         
         if s.upcase.include?(@symbolName) or s.upcase.include?(@symbol)
            
            words = Array[]     
            words = s.gsub(/\s+/m, ' ').strip.split(" ")    
            
            
            # Iterate the words array          
            words.each do |s2|           
              
              # Count word if it equals a positive words            
              @positiveWordsArray.each do |line|          
                if s2.upcase == line              
                  puts s2 
                  positiveCounter = positiveCounter + 1                              
                end                  
              end
              
              # Count word if it equals a negative words   
              @negativeWordsArray.each do |line|
                if s2.upcase == line
                  puts s2                
                  negativeCounter = negativeCounter + 1     
                end                                 
              end
                                         
            end
                         
         end
                      
       end
       
     return { :Positive => positiveCounter, :Negative => negativeCounter, :Symbol => @symbol, :Date => Time.now.strftime("%d/%m/%Y")}
       
     end
    
  end
  
  
  t = Scraper.new('PYPL')
  #result = t.countWords('http://www.usatoday.com/story/money/markets/2015/12/14/apple-stock-fails-again/77290488/')
  result = t.scrapeCNNPage()
  puts "Positive words: " + result[:Positive].to_s
  puts "Negative words: " + result[:Negative].to_s
  puts result.to_json
  
   
end


