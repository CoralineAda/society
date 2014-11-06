require "fileutils"
require "active_support/core_ext/string/inflections"

require_relative "society/cli"
require_relative "society/association_processor"
require_relative "society/reference_processor"
require_relative "society/edge"
require_relative "society/formatter/core"
require_relative "society/formatter/heatmap"
require_relative "society/formatter/network"
require_relative "society/object_graph"
require_relative "society/parser"
require_relative "society/version"

module Society
  def self.analyze_classes(path)
    parser = Society::Parser.new(path)
    graph = parser.class_graph
    heatmap_json = parser.formatters(graph).heatmap.to_json
    network_json = parser.formatters(graph).network.to_json

    data_dir = File.join(File.dirname(__FILE__), '..', 'doc', 'data')

    file = File.open(File.join(data_dir, 'heatmap.json'), 'w')
    file.write heatmap_json
    file.close

    file = File.open(File.join(data_dir, 'network.json'), 'w')
    file.write network_json
    file.close

    #for debugging, return the unresolved edges
    parser.unresolved_edges
  end
end

