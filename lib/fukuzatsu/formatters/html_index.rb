module Fukuzatsu

  module Formatters

    class HtmlIndex

      include Formatters::Base

      attr_reader :summaries

      def initialize(summaries)
        @summaries = summaries
      end

      def content
        Haml::Engine.new(output_template).render(
          Object.new, {
            summaries: summaries,
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

      def file_extension
        ".htm"
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

end
