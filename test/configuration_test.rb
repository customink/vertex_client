require "test_helper"

describe VertexClient::Configuration do
  it 'has a trusted id' do
    VertexClient.configuration.trusted_id = 'trusted-id'
    assert_equal VertexClient.configuration.trusted_id, 'trusted-id'
  end

  it 'has a soap_api' do
    VertexClient.configuration.soap_api = 'http://service.example.com'
    assert_equal VertexClient.configuration.soap_api, 'http://service.example.com'
  end
end
