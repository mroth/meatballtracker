require 'bundler'
require 'rspec/core/rake_task'
require 'rake/clean'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

CLEAN.include('./tmp/*.pdf')
CLOBBER.include('./tmp')

desc "Download the latest menu to the sample fixtures"
task :download_sample_menu do
  require './lib/meatballtracker/tracker'
  curr_url = Meatballtracker::Tracker.new.current_menu_url
  Dir.chdir('spec/sample_menus') do
    `wget -nc #{curr_url}`
  end
end