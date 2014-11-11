module Fukuzatsu

  module Formatters

    class JsonIndex

      include Formatters::Base

      attr_reader :summaries

      def initialize(summaries)
        @summaries = summaries
      end

      def content
        summaries.map { |summary| Json.new(summary: summary).as_json }.to_json
      end

      def filename
        "results.json"
      end

      def file_extension
        ".json"
      end

    end

  end

end
