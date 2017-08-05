# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shopify_app/kit/version"

Gem::Specification.new do |spec|
  spec.name          = "shopify_app-kit"
  spec.version       = ShopifyApp::Kit::VERSION


  spec.summary       = %q{This is a Rails addon for Kit integration}
  spec.description   = %q{This gem contains routes, actions and model mixins to handle Kit conversations }
  spec.authors       = ["Pemberton Rank Ltd"]
  spec.email         = ["hello@pembertonrank.com"]
  spec.homepage      = "https://www.pembertonrank.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails'
  spec.add_dependency 'active_model_serializers'
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'factory_girl_rails'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rspec-benchmark'
  spec.add_development_dependency 'webmock'
end
