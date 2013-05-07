require 'spec_helper'

describe Tweeter do
  describe ".new"  do
    it "should be initialized from and just handle a MenuParser itself"
  end

  describe ".new_from_menu"  do
    it "should be initialized from and just handle a MenuParser itself" do
      @menu1 = MenuParser.new('./spec/sample_menus/Dinner4-30.pdf')
      t = Tweeter.new_from_menu(@menu1)
    end
  end

  describe "#format_msg" do
    it "should replace the menu url with a bitly shorturl"
    it "should return a nicely formatted string" do
      t = Tweeter.new(
        "november 31, 2013",
        "http://www.superlongassurl.yougottabekidding.me/menu_for_today.pdf",
        true,
        "meatballs with extra super spicy sauce"
        )
      t.format_str.length.should be <= 140
    end
    it "should return strings under 140 characters"
  end

  describe ".time_since_last_tweet" do
    it "should return how long it's been since the most recent menu tweet"
    #TODO: needed? Or can twitter duplicate handling nail this? prob not if file name changes...
  end
end