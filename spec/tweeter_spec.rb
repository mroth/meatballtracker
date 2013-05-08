require 'spec_helper'

describe TweetFormatter do
  describe ".new"  do
    it "should be initialized from and just handle a MenuParser itself"
  end

  describe ".new_from_menu"  do
    it "should be initialized from and just handle a MenuParser itself" do
      @menu1 = MenuParser.new('./spec/sample_menus/Dinner4-30.pdf')
      t = TweetFormatter.new_from_menu(@menu1)
    end
  end

  describe "#format_msg" do
    before(:each) do
        @t = TweetFormatter.new(
        "november 31, 2013",
        "http://www.superlongassurl.yougottabekidding.me/menu_for_today.pdf",
        true,
        "meatballs with extra super spicy sauce"
        )
    end
    it "should replace the menu url with a bitly shorturl"
    it "should return a nicely formatted string"
    it "should include the name of the menu item in the string"
    it "should return strings under 140 characters" do
      @t.format_str.length.should be <= 140
    end
  end

end

describe Tweeter do
  describe ".time_since_last_tweet" do
    it "should return how long it's been since the most recent menu tweet"
    #TODO: needed? Or can twitter duplicate handling nail this? prob not if file name changes...
  end
  describe ".most_recent_posted_menu_url" do
    it "should return a recent url" do
      Tweeter.most_recent_posted_menu_url.should include('http://j.mp')
    end
    it "should return nil if most_recent_posted_menu_tweet is nil" do
      Tweeter.stub(:most_recent_posted_menu_tweet) { nil }
      Tweeter.most_recent_posted_menu_url.should eq(nil)
    end
  end
end