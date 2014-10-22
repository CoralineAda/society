module Formatters

  class HtmlIndex

    include Formatters::Base

    attr_reader :file_summary, :output_directory

    def initialize(file_summary, output_directory=nil)
      @file_summary = file_summary
      @output_directory = output_directory
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

    def export
      begin
        File.open(path_to_results, 'w') {|outfile| outfile.write(content)}
      rescue Exception => e
        puts "Unable to write output: #{e} #{e.backtrace}"
      end
    end

    def filename
      "index.htm"
    end

    def output_path
      FileUtils.mkpath(self.output_directory)
      self.output_directory
    end

    def output_template
      File.read(File.dirname(__FILE__) + "/templates/index.html.haml")
    end

  end

end