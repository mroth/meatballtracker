require './lib/meatballtracker'
include Meatballtracker

#temporary until we put the real logic in
@tracker = Tracker.new
puts "Checking for new menu..."
previous_url = Tweeter.most_recent_posted_menu_url
if (@tracker.current_menu_url == previous_url)
  puts "Menu is still same as previous menu."
else
  puts "Menu appears to be new!"
  mp = MenuParser.new( @tracker.current_menu_url )
  puts TweetFormatter.new_from_menu(mp).format_str
end
# pseudo logic
#  init a Tracker
#  ask Tracker if there are new updates
#   if no, log message and die
#  if yes, get most recent menu from Tracker and pass to MenuParser
#  output for logs the status of MenuParser
#  pass init'd MenuParser to Tweeter to post to Twitter (check for env var?)
