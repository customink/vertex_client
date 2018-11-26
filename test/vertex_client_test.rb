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

  describe 'circuit' do
    it 'only exists if circuit_config is provided to configuration' do
      VertexClient.configuration.circuit_config = nil
      assert_nil VertexClient.circuit
      VertexClient.reconfigure!
      VertexClient.configuration.circuit_config = {}
      assert VertexClient.circuit
    end

    it 'can be configured from Configuration#circuit_config' do
      logger = Logger.new(STDOUT)
      Circuitbox.reset
      VertexClient.configure do |c|
        c.circuit_config = { logger: logger }
      end
      assert_equal VertexClient.circuit.circuit_options[:logger], logger
    end
  end
end
