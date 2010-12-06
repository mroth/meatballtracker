#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'grackle'
require 'bitly'
require 'yaml'

#initialize helper libraries
ROOT = File.dirname(__FILE__) unless defined?(ROOT)
CONFIG = YAML.load_file("#{ROOT}/config.yml") unless defined? CONFIG
client = Grackle::Client.new(:auth=>{
    :type=>:oauth,
    :consumer_key=>CONFIG['twitter_consumer_key'], :consumer_secret=>CONFIG['twitter_consumer_secret'],
    :token=>CONFIG['twitter_token'], :token_secret=>CONFIG['twitter_token_secret']
})

#Bitly.use_api_version_3
bitly = Bitly.new(CONFIG['bitly_user'],CONFIG['bitly_apikey'])
agent = Mechanize.new
  
#check and see most recent menu
puts "*** Checking Boot and Shoe website"
agent.get("http://bootandshoeservice.com/")
menu_url=agent.page.links.first.href.strip

#what did we last post to twitter?
tweets=client.statuses.user_timeline?
last_menu = nil
tweets.each do |tweet|
  if tweet.text =~ /\(full menu: (.*)\)/
    last_menu_tiny = $1
    puts "...Last tweeted menu: #{last_menu_tiny}"
    last_menu = bitly.expand(last_menu_tiny).long_url
    puts "...Expanded to #{last_menu}"
    break
  end
end

puts "...Most recent menu on website: #{menu_url}"

#compare menu urls
if last_menu == menu_url
  puts "*** Menus match! Exiting!"
  $stdout.flush
  Kernel.exit!
else
  puts "*** New menu!  Continue with the process!"
end

writeOut = open("#{ROOT}/today_menu.pdf", "wb")
writeOut.write(open(menu_url).read)
writeOut.close
puts 'downloaded menu'
`/usr/bin/pdftotext #{ROOT}/today_menu.pdf #{ROOT}/today_menu.txt`
puts 'converted menu to text'


menu = IO.readlines("#{ROOT}/today_menu.txt")
date = menu.first.chomp

meatballs = 0
menu.each do |line|
  if line =~ /meatball/
    meatballs = 1
  end
end

if (meatballs == 1)
  meatstr = "...AND IT HAS MEATBALLS!"
else
  meatstr = "...no meatballs :sadface:"
end

menu_url_short = bitly.shorten(menu_url).jmp_url
update_str = "Boot & Shoe Service menu posted for #{date}: #{meatstr} (full menu: #{menu_url_short})"
puts update_str

client.statuses.update! :status=>update_str, :place_id => '6f45fa9c65c14be7'
