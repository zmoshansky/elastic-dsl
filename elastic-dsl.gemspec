Gem::Specification.new do |s|
  s.name          = "elastic-dsl"
  # s.version       = ElasticDSL::Rails::VERSION
  s.version       = '0.0.0'
  s.authors       = ["Zachary Moshansky"]
  s.email         = ["karel.minarik@elasticsearch.org"]
  s.description   = "DSL Builder for Elasticsearch. (Not Affiliated)"
  s.summary       = "DSL Builder for Elasticsearch."
  s.homepage      = "https://github.com/zmoshansky/elastic_dsl"
  s.license       = "Apache 2"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
