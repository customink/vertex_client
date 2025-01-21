
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vertex_client/version"

Gem::Specification.new do |spec|
  spec.name          = "vertex_client"
  spec.version       = VertexClient::VERSION
  spec.authors       = ["Custom Ink"]
  spec.email         = ["technology@customink.com", "tailor.made@customink.com"]
  spec.required_ruby_version = '>= 2.1'
  spec.summary       = %q{A Ruby Gem to integrate with the Vertex Cloud API}
  spec.description   = %q{The Vertex Client Ruby Gem provides an interface to integrate with Vertex Cloud's SOAP API.}
  spec.homepage      = "https://github.com/customink/vertex_client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/customink/vertex_client"
    spec.metadata["changelog_uri"] = "https://github.com/customink/vertex_client/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "rack", "~> 2.2"
  spec.add_dependency "savon", ">= 2.11"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "circuitbox"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rack", "~> 2.2.10"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
