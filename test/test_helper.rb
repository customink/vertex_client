# frozen_string_literal: true

# SimpleCov configuration always goes first to ensure that we are generating correct code-coverage reports.
# But we only use SimpleCov on the CI System
if ENV.fetch('CI') { false }
  require 'simplecov'
  SimpleCov.start
end

# Extend the $LOAD_PATH with our lib library. This allows us to require the gem normally like Bundler would do.
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

# Require all support gems needed to ensure that our tests are working.
require 'vertex_client'
require 'minitest/autorun'
require 'mocha/minitest'

require 'minitest-ci' if ENV.fetch('CI') { false }

# Require all files that are currently in the test/support folder. This allows us to load additional configuration
# and keep the test_helper clean and concise.
test_root = File.dirname(__FILE__)
Dir[File.join(test_root, 'support/**.rb')].sort.each { |file| require file }

# Configure the client, these settings can be found inside the .env file which are automatically loaded for our test.
VertexClient.configuration
