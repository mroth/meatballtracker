module Meatballtracker
  class Tweeter
    def initialize(menu_date, menu_url, contains_meatballs, menu_item = nil)
      @menu_date = menu_date
      @menu_url = menu_url
      @contains_meatballs = contains_meatballs
      @menu_item = menu_item
    end

    def self.new_from_menu(menu)
      Tweeter.new(menu.menu_date, menu.uri, menu.is_delicious?, menu.delicious_item)
    end

    def format_str
      prelude + meatball_str + menu_link
      # if contains_meatballs
      #   return prelude + ", AND IT CONTAINS MEATBALLS! " + self.menu_link
      # elseu
      #   return self.prelude + ", sadly without meatballs. " + self.menu_link
      # end
    end

    protected
    def prelude
      "Boot and Shoe Service menu for #{@menu_date} posted"
    end

    def meatball_str
      @contains_meatballs ? " - AND IT CONTAINS MEATBALLS!" : "; sadly without meatballs."
    end

    def menu_link
      " (menu: LINK)"
    end
  end
end