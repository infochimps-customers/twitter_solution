require 'json'  
require 'open-uri'
require 'rubygems'
require 'twitter'

class TrstrankController < ActionController::Base
  


  # Your Infochimps API Key
  API_KEY = 'JimEngland-Hw3n_vzMB283_I1dXT7f9zgHU69'  
  
    # A hash of Twitter usernames that recently followed our account
  USERNAMES = %w{aseever dhruvbansal HustonHoburg JimEngland josephkelly misswinnie mrflip nickducoff sinned TimGasper}
  
  def index
  end
  
  # Use the Infochimps Trst Rank API to get influence metrics
  def influencemetrics  
    result = {}
    @table = []

    USERNAMES.each do |u|        
      query = 'http://api.infochimps.com/social/network/tw/influence/metrics?apikey=' + API_KEY + '&screen_name=' + u    
      buffer = open(query).read
      result[u] = JSON.parse(buffer)
      @table << [u.to_s, result[u]['sway']]          
    end
    
    #Sort the table by sway
    @table.sort!{ |x,y| y[1]<=>x[1] }
    
    render 'trstrank/table'
  end
  
  
  def trstrank
    result = {}
    @table = []
  
    USERNAMES.each do |u|
      query = 'http://api.infochimps.com/social/network/tw/influence/trstrank?apikey=' + API_KEY + '&screen_name=' + u
      buffer = open(query).read
      result[u] = JSON.parse(buffer)
      @table << [u.to_s, result[u]['trstrank']]        
    end  
    
    #Sort the table by trstrank
    @table.sort!{ |x,y| y[1]<=>x[1] }

    render 'trstrank/table'  
  end
  
  
  def stronglinks
    result = {}
    @table = []

    #Twitter Credentials
    Twitter.configure { |config|
      config.consumer_key = '14924402-DQNDRg4fpguFOJzCqwOAYPlm3T7TRV7IAA7nblFAL'
      config.consumer_secret = 'LYL5BKSTkNR6G6ifg5DU0jxP8BGaNY3CBGsMd2aUfI'
      config.endpoint = 'http://twitter-api-app697331.apigee.com'
   }  
  
    USERNAMES.each do |u|  
      query = 'http://api.infochimps.com/social/network/tw/graph/strong_links?apikey=' + API_KEY + '&screen_name=' + u    
      buffer = open(query).read
      result[u] = JSON.parse(buffer)
        
      result[u]['strong_links'][0...3].each do |link|        
        begin
          name = Twitter.user(link[0])['screen_name'] unless Twitter.friendship?(link[0], 15748351) 
          rescue Twitter::Error   
          ensure
          @table << [u, name] if name   
        end                
      end
    
    end

    render 'trstrank/table'  
  end
  
end
