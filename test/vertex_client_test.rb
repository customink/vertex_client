require "test_helper"

describe VertexClient do

  include TestInput

  it 'has a version number' do
    refute_nil ::VertexClient::VERSION
  end

  it 'can be configured with envs' do
    refute_nil ENV['VERTEX_TRUSTED_ID']
    assert_equal VertexClient.configuration.trusted_id, ENV['VERTEX_TRUSTED_ID']
  end

  it 'can be configured with a block' do
    VertexClient.configure { |config| config.trusted_id = 'trusted-id' }
    assert_equal VertexClient.configuration.trusted_id, 'trusted-id'
    VertexClient.reconfigure!
  end

  describe 'circuit' do
    before do
      Circuitbox.reset
      VertexClient.reconfigure!
    end

    after do
      Circuitbox.reset
      VertexClient.reconfigure!
    end

    it 'only exists if circuit_config is provided to configuration' do
      VertexClient.configuration.circuit_config = nil
      assert_nil VertexClient.circuit
      VertexClient.reconfigure!
      VertexClient.configuration.circuit_config = {}
      assert VertexClient.circuit
    end

    it 'can be configured from Configuration#circuit_config' do
      logger = Logger.new(STDOUT)
      VertexClient.configure do |c|
        c.circuit_config = { logger: logger }
      end
      assert_equal VertexClient.circuit.circuit_options[:logger], logger
    end

    it 'opens the circuit' do
      VCR.use_cassette('circuit_breaker', allow_playback_repeats: true, match_requests_on: []) do

        VertexClient.configuration.circuit_config = {
          logger: FakeLogger.new
        }

        # "Not Open" means that we are actively hitting the service.
        VertexClient.configuration.trusted_id  = '💩'
        refute VertexClient.circuit.open?

        # Exhaust the configured volume threshold to open the circuit.
        # "Open" means that we aren't going to connect to the service.
        threads = []
        (VertexClient::Configuration::CIRCUIT_CONFIG[:volume_threshold] + 1).times do
          threads << Thread.new { VertexClient.quotation(working_quote_params) }
        end
        threads.each(&:join)

        assert VertexClient.circuit.open?
        assert_nil VertexClient.quotation(working_quote_params)
      end
    end
  end
end
