require "test_helper"

describe VertexClient::Configuration do
  it 'has a trusted id' do
    VertexClient.configuration.trusted_id = 'trusted-id'
    assert_equal VertexClient.configuration.trusted_id, 'trusted-id'
  end
end
