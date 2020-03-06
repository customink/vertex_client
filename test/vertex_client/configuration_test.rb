# frozen_string_literal: true

require 'test_helper'

describe VertexClient::Configuration do
  let(:default_timeout) { 5 }

  after { VertexClient.reconfigure! }

  describe '#trusted_id' do
    it 'loads the value by default from the environment variable' do
      refute_empty VertexClient.configuration.trusted_id
    end

    it 'allows the value to be overwritten' do
      VertexClient.configuration.trusted_id = 'trusted-id'
      assert_equal 'trusted-id', VertexClient.configuration.trusted_id
    end
  end

  describe '#soap_api' do
    it 'loads the value by default from the environment variable' do
      refute_empty VertexClient.configuration.soap_api
    end

    it 'allows the value to be overwritten' do
      VertexClient.configuration.soap_api = 'http://service.example.com'
      assert_equal 'http://service.example.com/', VertexClient.configuration.soap_api
    end
  end

  describe '#fallback_rates' do
    it 'returns the fallback rates defined in the client' do
      assert_equal VertexClient::RATES, VertexClient.configuration.fallback_rates
    end
  end

  describe '#open_timeout' do
    it 'has a default value of 5 seconds' do
      assert_equal default_timeout, VertexClient.configuration.open_timeout
    end

    it 'allows a different value to be set' do
      VertexClient.configuration.open_timeout = 10
      assert_equal 10, VertexClient.configuration.open_timeout
    end
  end

  describe '#read_timeout' do
    it 'has a default value of 5 seconds' do
      assert_equal default_timeout, VertexClient.configuration.read_timeout
    end

    it 'allows a different value to be set' do
      VertexClient.configuration.read_timeout = 10
      assert_equal 10, VertexClient.configuration.read_timeout
    end
  end

  describe 'resource_config' do
    it 'returns an empty configuration by default' do
      assert_equal({}, VertexClient.configuration.resource_config)
    end

    it 'allows configuration of resources' do
      VertexClient.reconfigure! do |config|
        config.resource_config = {
          quotation: { read_timeout: 1, open_timeout: 2 },
          invoice: { read_timeout: 30, open_timeout: 35 }
        }
      end
      assert_equal({ read_timeout: 1, open_timeout: 2 }, VertexClient.configuration.resource_config[:quotation])
      assert_equal({ read_timeout: 30, open_timeout: 35 }, VertexClient.configuration.resource_config[:invoice])
    end
  end
end
