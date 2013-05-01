module Meatballtracker
  class Parser
    attr_reader :uri, :local_path

    def initialize(uri: nil, local_path: nil)
      @uri = uri
      @local_path = local_path
    end

    def retrieve_file
    end

    def text
      self.retrieve_file if @local_path.nil?
      @text ||= `pdftotext #{@local_path} -`
    end

    def menu_date
      self.text.lines.first.chomp
    end

  end
end