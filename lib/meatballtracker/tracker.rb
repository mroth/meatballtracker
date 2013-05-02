require 'nokogiri'
require 'open-uri'

module Meatballtracker
  class Tracker

    def initialize
      @doc = Nokogiri::HTML(open('http://bootandshoeservice.com'))
    end

    def current_menu_url
      @doc.at_css('img [title=dinner]').parent.attributes['href'].value
    end

  end
end