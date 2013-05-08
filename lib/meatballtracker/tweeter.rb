require 'dotenv'; Dotenv.load
require 'twitter'
Twitter.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end
require 'bitly'
Bitly.configure do |config|
  config.api_version = 3
  config.login   = ENV['BITLY_USER']
  config.api_key = ENV['BITLY_APIKEY']
end

module Meatballtracker

  class Tweeter
    MENU_REGEX = /\((?:full menu|menu): (.*)\)/

    def self.most_recent_posted_menu_url
      return nil if self.most_recent_posted_menu_tweet.nil?
      if self.most_recent_posted_menu_tweet.text =~ MENU_REGEX
        return Bitly.client.expand($1).long_url
      end
      nil
    end

    def self.most_recent_posted_menu_tweet
      @@menu_tweet ||= Twitter.user_timeline.find { |tweet| tweet.text =~ MENU_REGEX }
    end

    def self.post(msg)
      puts "NOT REALLY TWEETING FOR NOW LOL"
      puts msg
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
      "#{prelude}#{meatball_str} (#{menu_item_str}#{menu_link})"
    end

    protected
    def prelude
      "Boot and Shoe Service menu posted for #{@menu_date}"
    end

    def meatball_str
      @contains_meatballs ? " - AND IT CONTAINS MEATBALLS!" : "... sadly no meatballs."
    end

    def menu_link
      "menu: #{@menu_url}"
    end

    def menu_item_str
      return nil if @menu_item.nil?
      #TODO: truncate string length based on remainaing chars
      "#{@menu_item}; "
    end
  end

end