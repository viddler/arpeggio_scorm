# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arpeggio_scorm_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "arpeggio_scorm_generator"
  spec.version       = ArpeggioScormGenerator::VERSION
  spec.authors       = ["Matt Fawcett"]
  spec.email         = ["fawcett@viddler.com"]

  spec.summary       = %q{A library for generating a zip file scorm package of an Arpeggio player}
  spec.description   = %q{A library for generating a zip file scorm package of an Arpeggio player}
  spec.homepage      = "http://www.viddler.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rubyzip", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.7"
end
