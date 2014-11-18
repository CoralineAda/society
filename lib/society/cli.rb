require "thor"

module Society

  class CLI < Thor

    desc_text = "Formats are html (default) and json."
    desc_text << "Example: society from foo/ -f json"

    desc "from PATH_TO_FILE [-f FORMAT]", desc_text
    method_option :format, :type => :string, :default => 'text', :aliases => "-f"

    def from(path="./")
      parser = Society::Parser.new(path, formatter)
      parser.parse_files
      parser.report
    end

    default_task :from

    private

    def formatter
      if options['format'] && options['format'] == 'json'
        Formatters::Json
      else
        Formatters::Text
      end
    end

  end

end