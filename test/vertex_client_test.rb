require "test_helper"

describe VertexClient do
  it 'has a version number' do
    refute_nil ::VertexClient::VERSION
  end

  it 'can be configured with envs' do
    ENV['VERTEX_TRUSTED_ID'] = 'trusted-id'
    VertexClient.reconfigure!
    assert_equal VertexClient.configuration.trusted_id, 'trusted-id'
  end

  it 'can be configured with a block' do
    VertexClient.configure { |config| config.trusted_id = 'trusted-id' }
    assert_equal VertexClient.configuration.trusted_id, 'trusted-id'
  end
end
