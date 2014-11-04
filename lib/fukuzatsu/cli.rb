require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc_text = "Formats are text (default, to STDOUT), html, and csv. "
    desc_text << "Example: fuku check foo/ -f html"

    desc "check PATH_TO_FILE [-f FORMAT] [-t MAX_COMPLEXITY_ALLOWED]", desc_text
    method_option :format, :type => :string, :default => 'text', :aliases => "-f"
    method_option :threshold, :type => :numeric, :default => 0, :aliases => "-t"

    def check(path="./")
      parser = Fukuzatsu.new(
        path,
        formatter,
        options['threshold']
      )
      parser.report
    end

    default_task :check

    private

    def formatter
      options['format'] && options['format'].to_sym || :text
    end

  end

end
