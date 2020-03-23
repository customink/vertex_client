require 'test_helper'

describe VertexClient::Configuration do
  after do
    VertexClient.reconfigure!
  end

  it 'has a trusted id' do
    VertexClient.configuration.trusted_id = 'trusted-id'
    assert_equal 'trusted-id', VertexClient.configuration.trusted_id
    VertexClient.reconfigure!
  end

  it 'has a soap_api, and adds a trailing slash to it' do
    VertexClient.configuration.soap_api = 'http://service.example.com'
    assert_equal 'http://service.example.com/', VertexClient.configuration.soap_api
    VertexClient.reconfigure!
  end

  it 'has a read_timeout default option and can be set' do
    assert_equal 5, VertexClient.configuration.read_timeout
    VertexClient.configuration.read_timeout = 10
    assert_equal 10, VertexClient.configuration.read_timeout
  end

  it 'has an open_timeout defalt option and can be set' do
    assert_equal 5, VertexClient.configuration.open_timeout
    VertexClient.configuration.open_timeout = 10
    assert_equal 10, VertexClient.configuration.open_timeout
  end

  describe 'global_options' do
    it 'returns an empty has by default and can set a hash' do
      assert_instance_of Hash, VertexClient.configuration.global_options
      VertexClient.configuration.global_options = { foo: 'bar' }
      assert_equal 'bar', VertexClient.configuration.global_options[:foo]
    end

    it 'defaults to net/http adapter' do
      assert_equal :net_http, VertexClient.configuration.global_options[:adapter]
    end
  end

  describe 'circuit_config' do
    before do
      VertexClient.reconfigure!
    end

    it 'is an accessible attribute' do
      VertexClient.configuration.circuit_config = { test: :ok }
      assert_equal :ok, VertexClient.configuration.circuit_config[:test]
    end

    it 'is nil if nothing is provided' do
      assert_nil VertexClient::Configuration.new.circuit_config
    end

    it 'merges in defaults from CIRCUIT_CONFIG' do
      VertexClient.reconfigure! do |config|
        config.circuit_config = { sleep_window: 300 }
      end

      assert_equal VertexClient.circuit.service, 'vertex_client'
      config_defaults = VertexClient::Configuration::CIRCUIT_CONFIG.reject{|k,_| k == :logger }
      config_defaults.each_pair do |key, value|
        assert_equal value, VertexClient.circuit.circuit_options[key]
      end
    end
  end

  describe 'resource_config' do
    it 'allows configuration of resources' do
      VertexClient.reconfigure! do |config|
        config.resource_config = {
          quotation:  { read_timeout: 1, open_timeout: 2 },
          invoice:    { read_timeout: 30, open_timeout: 35 }
        }
      end
      assert_equal({ read_timeout: 1, open_timeout: 2 }, VertexClient.configuration.resource_config[:quotation])
      assert_equal({ read_timeout: 30, open_timeout: 35 }, VertexClient.configuration.resource_config[:invoice])
    end
  end
end
