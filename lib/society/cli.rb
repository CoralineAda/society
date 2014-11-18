require "thor"
require "society"

module Society

  class CLI < Thor

    desc_text = "Formats are html (default) and json."
    desc_text << "Example: society from foo/ -f json"

    desc "from PATH_TO_FILE [-f FORMAT] [-o OUTPUT_DIRECTORY", desc_text
    method_option :format, :type => :string, :default => 'html', :aliases => "-f"
    method_option :output, :type => :string, :aliases => "-o"

    def from(path)
      Society.new(path).report(format, options['output'])
    end

    default_task :from

    private

    def format
      options['format'] && options['format'].to_sym
    end

  end

end