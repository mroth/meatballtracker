#!/usr/bin/env ruby
require 'rubygems'
require 'grackle'
require 'yaml'
require 'uri'
#require 'sparklines'

#initialize helper libraries
CONFIG = YAML.load_file("config.yml") unless defined? CONFIG
client = Grackle::Client.new(:auth=>{
    :type=>:oauth,
    :consumer_key=>CONFIG['twitter_consumer_key'], :consumer_secret=>CONFIG['twitter_consumer_secret'],
    :token=>CONFIG['twitter_token'], :token_secret=>CONFIG['twitter_token_secret']
})

  

#what did we last post to twitter?
tweets=client.statuses.user_timeline? :count => 200

results = Array.new
tweets.each do |tweet|
  if tweet.text =~ /menu posted for (.*?)\:/
    date = Time.parse( tweet.created_at )
    tweet.text =~ /sadface/ ? meat = -1 : meat = 1
    puts "#{date} #{meat}"
    results << meat
  end
end
meatyes = results.find_all{|i| i == 1}.length
meatno = results.find_all{|i| i == -1}.length
ratio = meatyes.to_f / results.length
percent = (Integer(ratio * 100) / Float(100)  * 100).to_i
summary = "MEATBALLTRACKER     days tracked: #{results.length}   meatballs: #{meatyes}   tragedies: #{meatno}   deliciousness rate: #{percent}%"
puts summary
# http://chart.apis.google.com/chart
#    ?chbh=a
#    &chs=400x50
#    &cht=bvg
#    &chco=A2C180
#    &chds=-1,1
#    &chd=t:-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1,1,1,1,-1,1,1,1,1,1,-1,-1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,-1,1,1,1,1,1,1,-1,-1,-1,1,1,1
#    &chtt=days+tracked%3A+49+meatballs%3A+23+tragedies%3A+26+success+rate%3A+88%
#    &chts=676767,10.5
chart_data = results.reverse.join(",")
chart_url = "http://chart.apis.google.com/chart
   ?chbh=a
   &chs=500x50
   &cht=bvg
   &chco=A2C180
   &chds=-1,1
   &chd=t:#{chart_data}
   &chtt=#{URI.escape(summary)}
   &chts=676767,10.5"
chart_url.delete!("\n")
chart_url.delete!(" ")
puts chart_url
system("open", chart_url)