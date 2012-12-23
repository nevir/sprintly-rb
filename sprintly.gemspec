# -*- encoding: utf-8 -*-
require File.expand_path("../lib/sprintly/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name        =  "sprintly"
  gem.description =  "A Ruby client to sprint.ly's API"
  gem.summary     =  "A Ruby client to sprint.ly's API"
  gem.authors     = ["Ian MacLeod"]
  gem.email       = ["ian@nevir.net"]
  gem.homepage    =  "https://github.com/nevir/sprintly-rb"

  gem.version  = Sprintly::VERSION
  gem.platform = Gem::Platform::RUBY

  gem.files      = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {spec}/*`.split("\n")

  gem.require_paths = ["lib"]

  # Modular HTTP/REST API client library.
  # MIT License - https://github.com/technoweenie/faraday/blob/master/LICENSE.md
  gem.add_runtime_dependency "faraday", "~> 0.8"

  # Collection of handy Faraday middleware
  # MIT Licnese - https://github.com/pengwynn/faraday_middleware/blob/master/LICENSE.md
  gem.add_runtime_dependency "faraday_middleware", "~> 0.9"
end
