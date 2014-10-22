require "thor"

module Society

  class CLI < Thor

    desc_text = ""

    desc "from PATH_TO_FILE", desc_text
    def from(path="./")
      parser = Society::Parser.new(path)
      parser.parse_files
      parser.report
    end

    default_task :from

    private

    def formatter
      Formatters::Text
    end

  end

end