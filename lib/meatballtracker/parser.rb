require 'fileutils'
require 'open-uri'

module Meatballtracker
  class Parser
    attr_reader :uri, :local_path

    def initialize(uri)
      @uri = uri
    end

    def retrieve_file
      menu = open @uri
      FileUtils.mkdir_p 'tmp'
      cached_copy = open("./tmp/cached_menu_#{self.object_id}.pdf", "wb")
      cached_copy.write menu.read
      cached_copy.close
      @local_path = cached_copy.path
    end

    def text
      self.retrieve_file if @local_path.nil?
      @text ||= `pdftotext #{@local_path} -`
    end

    # Public: what was the posted date on the menu?
    #
    # Examples:
    #   # => "april 23, 2013"
    #   # => "new years day"
    #
    # Returns a _human-written_ date as a String.
    def menu_date
      # currently, this is always the first line on their menu.
      # which is good, because otherwise it would be hard to parse when they do "cute" stuff
      self.text.lines.first.chomp
    end

    # Public: Does the menu have meatballs on it?
    #
    # Returns the potentially delicious Boolean.
    def is_delicious?
      self.text.include? "meatball"
    end

  end
end