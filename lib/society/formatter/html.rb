require 'json'

module Society

  module Formatter

    class HTML

      include Society::Formatter::Core

      attr_reader :heatmap_json, :network_json, :data_dir

      def initialize(heatmap_json:, network_json:, data_dir:)
        @heatmap_json = heatmap_json
        @network_json = network_json
        @data_dir = data_dir
      end

      def write
        write_headmap_json
        write_network_json
      end

      private

      def write_heatmap_json
        file = File.open(File.join(data_dir, 'heatmap.json'), 'w')
        file.write heatmap_json
        file.close
      end

      def write_network_json
        file = File.open(File.join(data_dir, 'network.json'), 'w')
        file.write network_json
        file.close
      end

    end

  end

end
