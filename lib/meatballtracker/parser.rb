require 'fileutils'
require 'open-uri'

module Meatballtracker
  # Public: The main menu parser for retrieving, caching and parsing PDF menus.
  # Also contains convenience methods for parsing out the specific menu data we want.
  class Parser
    attr_reader :uri, :local_path

    # Public: Initialize a menu Parser
    #
    # uri - A String containing the valid URI for the menu's remote location
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

    # Public: The full text of the menu as generated by pdftotext
    # We don't bother with -layout or anything fancy, this is a stream dump.
    #
    # Returns a bunch of messy text as a String.
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

    # Public: Try to extract the full menu item name containing meatballs
    #
    # Examples:
    #   # => "rigatoni with tomato sauce & meatballs"
    #   # => "meatballs al' pizzaiolo"
    #
    # Returns a menu item String or nil if nothing contains meatballs
    def delicious_item
      return nil unless self.is_delicious?

      p_text = cleaned_text
      p_text.lines.each do |line|
        next unless line =~ /meatball/
        if line =~ /^(.*meatball[^\.]*)\.\.\../
          return $1
        end
      end

      #if we get to here, our parser failed to locate the named meatballs
      #TODO: throw error? or just return generic string
      return "[unknown delicious item]"
    end

    protected
    def cleaned_text
      # * first strip out any persistent invalid chars in UTF-8
      #
      # use double encoding trick from here:
      # http://stackoverflow.com/questions/2982677/ruby-1-9-invalid-byte-sequence-in-utf-8
      cleaned = @text.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
      cleaned.encode!('UTF-8', 'UTF-16')

      # * reintroduce the line breaks to subsections
      # we dont want to use -layout for this as it adds new breaks.
      #
      # current logic -- find the end of a menu item from the ... followed by a price
      # which can contain decimals and periods, but also potentially asterisks
      # TODO: be on the lookout for menus with "MP" or something similar
      cleaned.gsub!( /(\.\.\. [\d\.\*]+) /, "\i\n" )
    end
  end
end