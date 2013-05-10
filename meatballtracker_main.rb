require './lib/meatballtracker'
include Meatballtracker

puts "Meatball tracker is at your service!"
unless Bizhours.new.open?
  puts "Hmm, we're currently closed for business, come back later..."
  exit 0
end

puts "Checking for online menu..."
previous_menu_url = Tweeter.most_recent_posted_menu_url
current_menu_url = Tracker.new.current_menu_url

puts "previous_url:\t#{previous_menu_url}"
puts "current_url:\t#{current_menu_url}"

if (current_menu_url == previous_menu_url)
  puts "Menu is still same as previous menu."
else
  puts "Menu appears to be new! Downloading and parsing it..."
  mp = MenuParser.new( current_menu_url )
  tweet = TweetFormatter.new_from_menu(mp).format_str
  Tweeter.post(tweet)
end
