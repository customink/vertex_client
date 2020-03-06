# frozen_string_literal: true

require_relative 'lib/vertex_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'vertex_client'
  spec.version       = VertexClient::VERSION
  spec.author        = 'Custom Ink'
  spec.email         = 'technology@customink.com'
  spec.summary       = 'A Ruby Gem to integrate with the Vertex Cloud API'
  spec.description   = 'The Vertex Client Ruby Gem provides an interface '\
                       "to integrate with Vertex Cloud's SOAP API."
  spec.homepage      = 'https://github.com/customink/vertex_client'
  spec.license       = 'MIT'
  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/customink/vertex_client/issues',
    'changelog_uri' => 'https://github.com/customink/vertex_client/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/customink/vertex_client/blob/master/README.md',
    'homepage_uri' => 'https://github.com/customink/vertex_client',
    'source_code_uri' => 'https://github.com/customink/vertex_client'
  }

  spec.files            = Dir['lib/**/*']
  spec.bindir           = 'exe'
  spec.executables      = %w[]
  spec.require_paths    = %w[lib]
  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt']

  spec.required_ruby_version = '>= 2.3'
  spec.required_rubygems_version = '>= 2.0'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'savon'

  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-vcr'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rake', '< 11'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-minitest'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
