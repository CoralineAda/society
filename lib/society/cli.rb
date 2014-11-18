require "thor"
require "society"

module Society

  class CLI < Thor

    desc_text = "Formats are html (default) and json."
    desc_text << "Example: society from foo/ -f json"

    desc "from PATH_TO_FILE [-f FORMAT]", desc_text
    method_option :format, :type => :string, :default => 'text', :aliases => "-f"

    def from(path="./")
      Society.new(path, formatter).report
    end

    default_task :from

    private

    def formatter
      if options['format'] && options['format'] == 'json'
        Society::Formatter::Json
      else
        Society::Formatter::Html
      end
    end

  end

end