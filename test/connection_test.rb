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

    describe 'if timeouts are provided' do
      before do
        VertexClient.reconfigure! do |config|
          config.open_timeout = 5
          config.read_timeout = 6
        end
      end

      it 'passes global timeout configuration to the client' do
        options = connection.client.globals.instance_variable_get(:@options)
        assert_equal(5, options[:open_timeout])
        assert_equal(6, options[:read_timeout])
      end

      it 'overrides global config with resource config if it is provided' do
        VertexClient.reconfigure! do |config|
          config.resource_config = {
            test: {
              open_timeout: 1,
              read_timeout: 2
            }
          }
        end
        options = connection.client.globals.instance_variable_get(:@options)
        assert_equal(1, options[:open_timeout])
        assert_equal(2, options[:read_timeout])
      end
    end

    describe 'if scaled timeouts are provided' do
      before do
        VertexClient.reconfigure! do |config|
          config.open_timeout = 20
          config.read_timeout = 15
          config.scale_timeout = true
          config.timeout_scaling_factor = 10
        end
      end

      it 'passes global timeout configuration to the client' do
        connection.payload["line_items"] = (0..600).to_a
        options = connection.client.globals.instance_variable_get(:@options)
        assert_equal(60, options[:open_timeout])
        assert_equal(60, options[:read_timeout])
      end

      it 'doesnt override scaled config with resource config if it is provided without scale_timeout: false' do
        VertexClient.reconfigure! do |config|
          config.resource_config = {
            test: {
              open_timeout: 1,
              read_timeout: 2
            }
          }
          config.scale_timeout = true
          config.timeout_scaling_factor = 10
        end
        connection.payload["line_items"] = (0..600).to_a
        options = connection.client.globals.instance_variable_get(:@options)
        assert_equal(60, options[:open_timeout])
        assert_equal(60, options[:read_timeout])
      end

      it 'overrides scaled config with resource config if it is provided with scale_timeout: false' do
        VertexClient.reconfigure! do |config|
          config.resource_config = {
            test: {
              open_timeout: 1,
              read_timeout: 2,
              scale_timeout: false
            }
          }
          config.scale_timeout = true
          config.timeout_scaling_factor = 10
        end
        connection.payload["line_items"] = (0..600).to_a
        options = connection.client.globals.instance_variable_get(:@options)
        assert_equal(1, options[:open_timeout])
        assert_equal(2, options[:read_timeout])
      end

      it 'allows a resource to set its own scaling factor' do
        VertexClient.reconfigure! do |config|
          config.resource_config = {
            test: {
              open_timeout: 1,
              read_timeout: 2,
              timeout_scaling_factor: 5 
            }
          }
          config.scale_timeout = true
          config.timeout_scaling_factor = 10
        end
        connection.payload["line_items"] = (0..600).to_a
        options = connection.client.globals.instance_variable_get(:@options)
        assert_equal(120, options[:open_timeout])
        assert_equal(120, options[:read_timeout])
      end

    end
  end

  describe 'request' do
    it 'calls client with a vertex envelope payload' do
      connection.send(:config).stubs(:trusted_id).returns(:secret)
      expected_message = {
        login: {
          trusted_id: connection.send(:config).trusted_id,
        },
        just_a_test: true
      }
      connection.client.expects(:call).with(:vertex_envelope, message: expected_message)
      connection.request({ just_a_test: true })
    end
  end

  describe 'config' do
    it 'is an instance of VertexClient::Configuration' do
      assert_kind_of VertexClient::Configuration, connection.send(:config)
    end
  end

  describe 'resource_config' do
    before do
      VertexClient.reconfigure! do |config|
        config.resource_config = {
          test: {
            open_timeout: 1,
            read_timeout: 2
          }
        }
      end
    end

    it 'is an object that stores per-resource configuration' do
      assert_equal({ open_timeout: 1, read_timeout: 2 }, connection.send(:resource_config))
    end

    describe 'open_timeout' do
      it 'is read from resource_config if available, otherwise it is read from defaults' do
        assert_equal 1, connection.send(:open_timeout)
        connection.instance_variable_set(:@config, nil)
        VertexClient.reconfigure! do |config|
          config.resource_config = nil
          config.open_timeout = 5
        end
        assert_equal 5, connection.send(:open_timeout)
      end
    end

    describe 'read_timeout' do
      it 'is read from resource_config if available, otherwise it is read from defaults' do
        assert_equal 2, connection.send(:read_timeout)
        connection.instance_variable_set(:@config, nil)
        VertexClient.reconfigure! do |config|
          config.resource_config = nil
          config.read_timeout = 5
        end
        assert_equal 5, connection.send(:read_timeout)
      end
    end
  end
end
