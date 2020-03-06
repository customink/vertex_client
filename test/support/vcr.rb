# frozen_string_literal: true

# This file contains all the code needed to properly configure VCR to run under the Minitest framework.
require 'vcr'
require 'minitest-vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.default_cassette_options = {
    record: ENV.fetch('CI') { false } ? :none : :new_episodes,
    erb: true,
    match_requests_on: %i[method uri body],
    re_record_interval: 1.month
  }
  config.filter_sensitive_data('<VERTEX_TRUSTED_ID>') { ENV.fetch('VERTEX_TRUSTED_ID') }
  config.filter_sensitive_data('<VERTEX_SOAP_API>')   { ENV.fetch('VERTEX_SOAP_API') }
end

# To ensure that VCR is injected properly into the Minitest framework
MinitestVcr::Spec.configure!
