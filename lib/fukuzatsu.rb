require 'ephemeral'
require 'poro_plus'
require 'fileutils'
require 'haml'

require_relative "fukuzatsu/analyzer"
require_relative "fukuzatsu/cli"
require_relative "fukuzatsu/formatters/base"
require_relative "fukuzatsu/formatters/csv"
require_relative "fukuzatsu/formatters/html"
require_relative "fukuzatsu/formatters/html_index"
require_relative "fukuzatsu/formatters/text"
require_relative "fukuzatsu/line_of_code"
require_relative "fukuzatsu/parsed_file"
require_relative "fukuzatsu/parsed_method"
require_relative "fukuzatsu/version"

module Fukuzatsu
end
