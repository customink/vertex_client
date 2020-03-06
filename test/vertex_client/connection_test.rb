# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/connection'

describe VertexClient::Connection, :vcr do
  subject { VertexClient::Connection.new(endpoint, resource_key) }

  let(:endpoint) { 'test' }
  let(:resource_key) { :test }

  it 'is initialized with the correct endpoint' do
    assert_equal endpoint, subject.instance_variable_get(:@endpoint)
  end

  it 'is initialized with the correct resource_key' do
    assert_equal resource_key, subject.instance_variable_get(:@resource_key)
  end

  describe 'client' do
    let(:expected_endpoint) { URI.join(VertexClient.configuration.soap_api, endpoint).to_s }
    let(:options) { subject.client.globals.instance_variable_get(:@options) }
    let(:supported_operations) { %i[] }

    it 'configures the Savon client with the correct endpoint' do
      assert_equal expected_endpoint, options[:endpoint]
    end

    it 'configures the Savon client with the correct namespace' do
      assert_equal VertexClient::Connection::VERTEX_NAMESPACE, options[:namespace]
    end

    it 'configures the Savon client with the correct env namespace' do
      assert_equal :soapenv, options[:env_namespace]
    end

    it 'configures the Savon client with the correct conversion options' do
      assert_equal :camelcase, options[:convert_request_keys_to]
    end

    it 'configures the Savon client with the correct read timeout settings' do
      assert_equal VertexClient.configuration.read_timeout, options[:read_timeout]
    end

    it 'configures the Savon client with the correct open timeout settings' do
      assert_equal VertexClient.configuration.open_timeout, options[:open_timeout]
    end
  end
end
