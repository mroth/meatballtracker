require 'tzinfo'

module Meatballtracker
  # Public: Utility functions for determining whether these are hours we should bother to check for updates
  class Bizhours
    HOUR_START  = 10 #the earliest we expect menu updates
    HOUR_END    = 22 #the latest we expect menu updates

    attr_reader :sf_tz

    def initialize
      @sf_tz = TZInfo::Timezone.get('America/Los_Angeles') #SF isn't important enough to have a timezone lol
    end

    def open?
      (HOUR_START..HOUR_END).include? @sf_tz.now.hour
    end

  end
end
