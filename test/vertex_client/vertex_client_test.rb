# frozen_string_literal: true

require 'test_helper'

describe VertexClient do
  include TestInput

  it 'has a version number' do
    refute_nil ::VertexClient::VERSION
  end

  it 'can be configured with a block' do
    VertexClient.configure { |config| config.trusted_id = 'trusted-id' }
    assert_equal 'trusted-id', VertexClient.configuration.trusted_id
    VertexClient.reconfigure!
  end
end
