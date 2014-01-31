# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octorelease/version'

Gem::Specification.new do |spec|
  spec.name          = "octorelease"
  spec.version       = OctoRelease::VERSION
  spec.authors       = ["Gosuke Miyashita"]
  spec.email         = ["gosukenator@gmail.com"]
  spec.summary       = %q{Octorelease.}
  spec.description   = %q{Octorelease.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "octokit"
  spec.add_runtime_dependency "hub"
  
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
