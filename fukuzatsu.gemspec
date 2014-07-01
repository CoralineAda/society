# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fukuzatsu/version'

Gem::Specification.new do |spec|
  spec.name          = "fukuzatsu"
  spec.version       = Fukuzatsu::VERSION
  spec.authors       = ["Bantik"]
  spec.email         = ["coraline@idolhands.com"]
  spec.summary       = "A simple cyclomatic complexity analyzer."
  spec.description   = "A simple cyclomatic complexity analyzer.."
  spec.homepage      = "https://gitlab.com/coraline/fukuzatsu"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "require_all"
  spec.add_dependency "ephemeral"
  spec.add_dependency "poro_plus"
  spec.add_dependency "haml"
  spec.add_dependency "parser"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "thor"

end
