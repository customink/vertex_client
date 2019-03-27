require 'test_helper'
describe VertexClient::Connection do
  let(:connection) { VertexClient::Connection.new('test', :test) }

  it 'initializes with an endpoint and resource_key' do
    assert_equal 'test', connection.instance_variable_get(:@endpoint)
    assert_equal :test, connection.instance_variable_get(:@resource_key)
  end

  describe 'client' do
    it 'is a configured savon client' do
      options = connection.client.globals.instance_variable_get(:@options)
      assert_equal 'https://connect.vertexsmb.com/vertex-ws/services/test', options[:endpoint]
      assert_equal 'urn:vertexinc:o-series:tps:7:0', options[:namespace]
      assert_equal :soapenv, options[:env_namespace]
      assert_equal :camelcase, options[:convert_request_keys_to]
    end
  end

  describe 'request' do
    it 'calls client with a vertex envelope payload' do
      connection.config.stubs(:trusted_id).returns(:secret)
      expected_message = {
        login: {
          trusted_id: connection.config.trusted_id,
        },
        just_a_test: true
      }
      connection.client.expects(:call).with(:vertex_envelope, message: expected_message)
      connection.request({ just_a_test: true })
    end
  end

  describe 'config' do
    it 'is an instance of VertexClient::Configuration' do
      assert_kind_of VertexClient::Configuration, connection.config
    end
  end
end
