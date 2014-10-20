require "thor"

module Society

  class CLI < thor

    desc_text = "society from PATH_TO_FILE"

    desc "from PATH_TO_FILE"
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