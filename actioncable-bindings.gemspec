# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'actioncable/bindings/version'

Gem::Specification.new do |spec|
  spec.name          = "actioncable-bindings"
  spec.version       = Actioncable::Bindings::VERSION
  spec.authors       = ["Lachlan Sylvester"]
  spec.email         = ["lachlan.sylvester@hypothetical.com.au"]

  spec.summary       = %q{DOM bindings for Action Cable}
  spec.description   = %q{Manage Action Cable subscriptions using data-* attributes}
  spec.homepage      = "https://github.com/lsylvester/actioncable-bindings"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "jquery-rails"

end
