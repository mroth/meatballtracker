require 'bundler'
require 'rspec/core/rake_task'
require 'rake/clean'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

CLEAN.include('./tmp/*.pdf')
CLOBBER.include('./tmp')

namespace :samples do
  desc "Download the latest menu to the sample fixtures"
  task :retrieve do
    require './lib/meatballtracker/tracker'
    curr_url = Meatballtracker::Tracker.new.current_menu_url
    Dir.chdir('spec/sample_menus') do
      `wget -nc #{curr_url}`
    end
  end

  desc "Test parse all sample menus and show what tweet would be generated"
  task :parse do
    require './lib/meatballtracker'
    include Meatballtracker
    FileList.new('./spec/sample_menus/*.pdf').each do |f|
      puts "\e[1m" + File.basename(f) + "\e[0m"
      mp = MenuParser.new( f )
      puts TweetFormatter.new_from_menu(mp).format_str
    end
  end
end