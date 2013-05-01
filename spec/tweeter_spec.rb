require 'spec_helper'

describe Tweeter do
  describe "#format_msg" do
    it "should require to know menu_date, contains_meatballs, and menu_url"
    it "should replace the menu url with a bitly shorturl"
    it "should return a nicely formatted string"
    it "should return strings under 140 characters"
  end
end