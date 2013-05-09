require './lib/meatballtracker'
include Meatballtracker

puts "Meatball tracker is at your service!"
unless Bizhours.new.open?
  puts "Hmm, we're currently closed for business, come back later..."
  exit 0
end

@tracker = Tracker.new
puts "Checking for new menu..."
previous_url = Tweeter.most_recent_posted_menu_url
if (@tracker.current_menu_url == previous_url)
  puts "Menu is still same as previous menu."
else
  puts "Menu appears to be new!"
  mp = MenuParser.new( @tracker.current_menu_url )
  tweet = TweetFormatter.new_from_menu(mp).format_str
  Tweeter.post(tweet)
end
