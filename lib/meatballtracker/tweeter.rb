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
    MENU_REGEX = /menu: (http.*)\)/

    def self.most_recent_posted_menu_url
      return nil if self.most_recent_posted_menu_tweet.nil?
      # if self.most_recent_posted_menu_tweet.text =~ MENU_REGEX
      #   return Bitly.client.expand($1).long_url
      # end
      # nil
      # FUCK YOU T.CO FOR BREAKING THE ABOVE - NEW (ADMITTEDLY EASIER) LOGIC BELOW
      jmp_url = self.most_recent_posted_menu_tweet.attrs[:entities][:urls].first[:expanded_url]
      Bitly.client.expand(jmp_url).long_url
    end

    def self.most_recent_posted_menu_tweet
      @@menu_tweet ||= Twitter.user_timeline.find { |tweet| tweet.text =~ MENU_REGEX }
    end

    def self.post(msg)
      puts "Formatted tweet: #{msg}"
      if self.is_live?
        response = Twitter.update(msg, :place_id => '6f45fa9c65c14be7')
        puts " -> " + "posted as https://twitter.com/#{response.user.screen_name}/status/#{response.id.to_s}"
      else
        puts " -> ***TEST MODE NOT REALLY TWEETING FOR NOW LOLZ!***"
      end
    end

    protected
    def self.is_live?
      !!(ENV['TWITTER_LIVE'] =~ /^(true|t|yes|y|1)$/i)
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
      "Menu posted for #{@menu_date}"
    end

    def meatball_str
      @contains_meatballs ? " - IT HAS MEATBALLS!" : "... sadly no meatballs."
    end

    def menu_link
      "menu: #{menu_url_short}"
    end

    def menu_url_short
      url_to_use = @menu_url
      unless url_to_use =~ /^(http:|https:)/ #handle case where we have local file objects for tests
        url_to_use = 'http://127.0.0.1/fake_from_tests'
      end
      @menu_url_short ||= Bitly.client.shorten(url_to_use).short_url
    end

    def menu_item_str
      return nil if @menu_item.nil?
      #TODO: truncate string length based on remainaing chars
      "#{menu_item_resized}; "
    end

    # string for the menu item, but truncated to fit if needed
    def menu_item_resized
      return @menu_item if @menu_item.length <= self.chars_remaining
      return @menu_item.slice(0,self.chars_remaining - 1) + "…"
    end

    # Protected: how many chars remain for the menu item in the tweet?
    def chars_remaining
      #add up everything except the menu item
      used = self.prelude.length + self.meatball_str.length + self.url_char_length

      #extra chars from string not encapsulated in other methods
      #maybe parse via regex sometime, but not worth it for now
      # format_str_extra = 3
      # menu_item_extra = 2
      # menu_link_extra = 5
      extra_chars = 3+2+5

      140 - (used + extra_chars)
    end

    # Protected: how many chars doe a URL take up?
    # We need to hardcode this based on twitter because of t.co wrapping
    def url_char_length
      23 #assume https for good measure
    end
  end

end