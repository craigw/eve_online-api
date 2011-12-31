# -*- encoding: utf-8 -*-
require File.expand_path('../lib/eve_online/api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Craig R Webster"]
  gem.email         = ["craig@barkingiguana.com"]
  gem.description   = %q{Ruby interface to the EVE Online API}
  gem.summary       = %q{Ruby interface to the EVE Online API}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "eve_online-api"
  gem.require_paths = ["lib"]
  gem.version       = EveOnline::Api::VERSION

  gem.add_runtime_dependency 'null_logger'
  gem.add_runtime_dependency 'active_support', '~> 3.0'
  gem.add_runtime_dependency 'nokogiri', '~> 1.5'
end
