require 'dotenv'; Dotenv.load
require 'twitter'

module Meatballtracker

  class Tweeter
    def self.most_recent_posted_menu_url
      if self.most_recent_posted_menu_tweet.text =~ /\(full menu: (.*)\)/
        return $1
      end
      nil
    end

    def self.most_recent_posted_menu_tweet
      Twitter.user_timeline.find { |tweet| tweet.text =~ /\(full menu: (.*)\)/ }
    end
  end

  class TweetFormatter
    def initialize(menu_date, menu_url, contains_meatballs, menu_item = nil)
      @menu_date = menu_date
      @menu_url = menu_url
      @contains_meatballs = contains_meatballs
      @menu_item = menu_item
    end

    def self.new_from_menu(menu)
      TweetFormatter.new(menu.menu_date, menu.uri, menu.is_delicious?, menu.delicious_item)
    end

    def format_str
      prelude + meatball_str + menu_link
    end

    protected
    def prelude
      "Boot and Shoe Service menu for #{@menu_date} posted"
    end

    def meatball_str
      @contains_meatballs ? " - AND IT CONTAINS MEATBALLS!" : "; sadly without meatballs."
    end

    def menu_link
      " (menu: #{@menu_url})"
    end
  end

end