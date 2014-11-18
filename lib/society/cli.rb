require "thor"
require "society"

module Society

  class CLI < Thor

    desc_text = "Formats are html (default) and json."
    desc_text << "Example: society from foo/ -f json"

    desc "from PATH_TO_FILE [-f FORMAT]", desc_text
    method_option :format, :type => :string, :default => 'html', :aliases => "-f"

    def from(path)
      Society.new(path, format).report
    end

    default_task :from

   private

    def format
      options['format'] && options['format'].to_sym
    end

  end

end