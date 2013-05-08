require 'spec_helper'

describe Tracker do

  describe ".new" do
    it "should initialize a nokogiri doc for the object"
    it "should die and throw a fatal error if cant reach the site"
  end

  describe "#current_menu_url" do
    it "should extract the current dinner menu url from the boot and shoe website" do
      Tracker.new.current_menu_url.should include('http://')
    end
    it "should throw a very noisy exception if it can't be found"
  end

  # describe "#current_menu_etag" do
  #   it "returns the ETag from the apache server hosting the menu"
  # end

end