module Formatters

  class HtmlIndex

    include Formatters::Base

    attr_reader :file_summary, :output_directory

    def initialize(file_summary, output_directory)
      @file_summary = file_summary
      @output_directory = output_directory
    end

    def filename
      "index.htm"
    end

    def output_path
      FileUtils.mkpath(self.output_directory)
      self.output_directory
    end

    def content
      Haml::Engine.new(output_template).render(
        Object.new, {
          file_summary: file_summary,
          date: Time.now.strftime("%Y/%m/%d"),
          time: Time.now.strftime("%l:%M %P")
        }
      )
    end

    def output_template
      File.read(File.dirname(__FILE__) + "/templates/index.html.haml")
    end

  end

end