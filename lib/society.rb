require "analyst"
require "fileutils"
require "active_support/core_ext/string/inflections"

require_relative "society/association_processor"
require_relative "society/reference_processor"
require_relative "society/edge"
require_relative "society/formatter/graph/json"
require_relative "society/formatter/report/html"
require_relative "society/formatter/report/json"
require_relative "society/object_graph"
require_relative "society/parser"
require_relative "society/version"

module Society

  def self.new(path_to_files)
    Society::Parser.for_files(path_to_files)
  end

end

