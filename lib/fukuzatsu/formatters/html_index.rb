module Formatters

  class HtmlIndex

    include Formatters::Base

    attr_accessor :file_summary

    def initialize(file_summary)
      self.file_summary = file_summary
    end

    def filename
      "index.htm"
    end

    def output_path
      output_path = "doc/fukuzatsu/"
      FileUtils.mkpath(output_path)
      output_path
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