# -*- encoding: utf-8 -*-
require File.expand_path('../lib/handy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Neeraj Singh"]
  gem.email         = ["neerajdotname@gmail.com"]
  gem.description   = %q{handy tool}
  gem.summary       = %q{Collection of handy tools}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "handy"
  gem.require_paths = ["lib"]
  gem.version       = Handy::VERSION
end
