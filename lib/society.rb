require "haml"
require "json"
require "ripper"
require "fileutils"
require "active_support/core_ext/string/inflections"

require_relative "society/edge"
require_relative "society/node"
require_relative "society/object_graph"
require_relative "society/formatter/report/html"
require_relative "society/formatter/report/json"
require_relative "society/parser"
require_relative "society/version"

raise 'Ruby version must be greater than 2.0' unless RUBY_VERSION.to_f > 2.0

module Society

  def self.new(*paths_to_files)
    Society::Parser.for_files(*paths_to_files)
  end

end

