require 'bundler'
require 'rspec/core/rake_task'
require 'rake/clean'
require 'colored'

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
      tweet = TweetFormatter.new_from_menu(mp).format_str
      print tweet.white
      puts " [#{tweet.length + 3}]".green
    end
  end
end

namespace :heroku do
  task :configure do
    `heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git`
    `heroku addons:add scheduler:standard`
    `heroku config:add PATH=/app/vendor/poppler/bin:/app/bin:/app/vendor/bundle/ruby/2.0.0/bin:/usr/local/bin:/usr/bin:/bin`
    `heroku config:push` #push env variables from .env
  end
end