require './lib/meatballtracker'
include Meatballtracker

#temporary until we put the real logic in
tracker = Tracker.new
mp = MenuParser.new( tracker.current_menu_url )
puts "Menu for #{mp.menu_date} #{mp.is_delicious? ? "does":"does not"} contain meatballs."
if mp.is_delicious?
  puts "The delicious menu item is: #{mp.delicious_item}"
end
# pseudo logic
#  init a Tracker
#  ask Tracker if there are new updates
#   if no, log message and die
#  if yes, get most recent menu from Tracker and pass to MenuParser
#  output for logs the status of MenuParser
#  pass init'd MenuParser to Tweeter to post to Twitter (check for env var?)
