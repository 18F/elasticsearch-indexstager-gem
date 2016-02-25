# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/index_stager'

Gem::Specification.new do |s|
  s.name          = 'elasticsearch-indexstager'
  s.version       = Elasticsearch::IndexStager::VERSION
  s.authors       = ['Peter Karman']
  s.email         = ['peter.karman@gsa.gov']
  s.summary       = 'manage Elasticsearch indexes using staging pattern'
  s.description   = (
    'manage Elasticsearch indexes using staging pattern'
  )
  s.homepage      = 'https://github.com/18F/elasticsearch-indexstager-gem'
  s.license       = 'CC0'

  s.files         = `git ls-files -z *.md bin lib`.split("\x0") + [
  ]
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }

  s.add_runtime_dependency 'elasticsearch'

  s.required_ruby_version = ">= 1.9.3"
  s.add_development_dependency 'about_yml'
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.add_development_dependency "elasticsearch-extensions"
end
