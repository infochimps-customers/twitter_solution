class TrstrankController < ApplicationController

  # Your Infochimps API Key
  API_KEY = 'XXXXXXXXXXXXXXXXXXXXX'  
  
  # A hash of Twitter usernames that recently followed our account
  USERNAMES = %w{aseever dhruvbansal HustonHoburg JimEngland josephkelly misswinnie mrflip nickducoff sinned TimGasper}

  
  # Use the Infochimps Influence Metrics API to get influence metrics
  # localhost/trstrank/influencemetrics
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
    
    @sentence = "The @Infochimps Twitter account should follow back " + @table[0...3].collect{|row| '@'+row.first }.to_sentence + "."
    
    render 'trstrank/table'
  end
  
  
  # Use the Infochimps Trstrank API to get trstrank score
  # localhost/trstrank/trstrank
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
   
    @sentence = "The @Infochimps Twitter account should @reply and thank " + @table[0...3].collect{|row| '@'+row.first }.to_sentence + "."

    render 'trstrank/table'  
  end

  
  # Use the Infochimps StrongLinks API to get strong connections
  # localhost/trstrank/stronglinks
  def stronglinks
    result = {}
    @table = []
  
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
    
    @sentence = "The @Infochimps Twitter account should follow " + @table.collect{|row| '@'+row.second }.uniq.to_sentence + "."

    render 'trstrank/table'  
  end
  
end
