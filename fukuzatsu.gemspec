# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fukuzatsu/version'

Gem::Specification.new do |spec|
  spec.name          = "fukuzatsu"
  spec.version       = Fukuzatsu::VERSION
  spec.authors       = ["Coraline Ada Ehmke", "Mike Ziwisky"]
  spec.email         = ["coraline@idolhands.com", "mikezx@gmail.com"]
  spec.summary       = "A simple code complexity analyzer."
  spec.description   = "Calculates code complexity as a measure of paths through code execution. CI integration and beautiful output options."
  spec.homepage      = "https://gitlab.com/coraline/fukuzatsu/tree/master"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "analyst", ">= 0.16.0"
  spec.add_dependency "ephemeral"
  spec.add_dependency "poro_plus"
  spec.add_dependency "haml"
  spec.add_dependency "parser"
  spec.add_dependency "rainbow"
  spec.add_dependency "rouge"
  spec.add_dependency "terminal-table"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"

end

