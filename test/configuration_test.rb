require "test_helper"

describe VertexClient::Configuration do
  it 'has a trusted id' do
    VertexClient.configuration.trusted_id = 'trusted-id'
    assert_equal VertexClient.configuration.trusted_id, 'trusted-id'
    VertexClient.reconfigure!
  end

  it 'has a soap_api, and adds a trailing slash to it' do
    VertexClient.configuration.soap_api = 'http://service.example.com'
    assert_equal VertexClient.configuration.soap_api, 'http://service.example.com/'
    VertexClient.reconfigure!
  end

  describe 'circuit_config' do
    before do
      VertexClient.reconfigure!
    end

    it 'is an accessible attribute' do
      VertexClient.configuration.circuit_config = { test: :ok }
      assert_equal VertexClient.configuration.circuit_config[:test], :ok
    end

    it 'is nil if nothing is provided' do
      assert_nil VertexClient::Configuration.new.circuit_config
    end

    it 'merges in defaults from CIRCUIT_CONFIG' do
      VertexClient.configuration.circuit_config = {}
      assert_equal VertexClient.circuit.service, 'vertex_client'
      config_defaults = VertexClient::Configuration::CIRCUIT_CONFIG.reject{|k,_| k == :logger }
      config_defaults.each_pair do |key, value|
        assert_equal VertexClient.circuit.circuit_options[key], value
      end
    end
  end
end
