require 'spec_helper'

describe Tracker do

  describe ".new" do
    it "should initialize a nokogiri doc for the object"
  end

  it "should keep track of the most recent menu seen"
  #TODO: handle lunch as well?
  it "should die and throw a fatal error if cant reach the site"

  describe "#current_dinner_menu_url" do
    it "should extract the current dinner menu url from the boot and shoe website"
    it "should throw a very noisy exception if it can't be found"
  end

  describe "#current_dinner_menu_etag" do
    it "returns the ETag from the apache server hosting the menu"
  end

  describe "#new_menu?" do
    it "should return true or false depending on whether a new menu exists"
  end
end