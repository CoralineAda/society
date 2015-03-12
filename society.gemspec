# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'society/version'

Gem::Specification.new do |spec|
  spec.name          = "society"
  spec.version       = Society::VERSION
  spec.authors       = ["Coraline Ada Ehmke"]
  spec.email         = ["coraline@instructure.com"]
  spec.summary       = %q{Social graph for Ruby objects}
  spec.description   = %q{Social graph for Ruby objects. Based on an original idea by Kerri Miller.}
  spec.homepage      = "https://github.com/CoralineAda/society"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1"

  spec.add_dependency "activesupport"
  spec.add_dependency "analyst", ">= 1.0.0"
  spec.add_dependency "parser"
  spec.add_dependency "rainbow"
  spec.add_dependency "terminal-table"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "awesome_print"

end
