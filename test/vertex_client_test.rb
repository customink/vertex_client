require 'test_helper'

describe VertexClient do

  include TestInput

  it 'has a version number' do
    refute_nil ::VertexClient::VERSION
  end

  it 'can be configured with a block' do
    VertexClient.configure { |config| config.trusted_id = 'trusted-id' }
    assert_equal 'trusted-id', VertexClient.configuration.trusted_id
    VertexClient.reconfigure!
  end

  it 'does a quotation' do
    VertexClient::Resource::Quotation.expects(:new)
      .with(working_quote_params)
      .returns(stub(result: true))
    assert VertexClient.quotation(working_quote_params)
  end

  it 'does invoice' do
    VertexClient::Resource::Invoice.expects(:new)
      .with(working_quote_params)
      .returns(stub(result: true))
    assert VertexClient.invoice(working_quote_params)
  end

  it 'does distribute_tax' do
    VertexClient::Resource::DistributeTax.expects(:new)
      .with(working_quote_params)
      .returns(stub(result: true))
    assert VertexClient.distribute_tax(working_quote_params)
  end

  it 'does tax_area' do
    VertexClient::Resource::TaxArea.expects(:new)
      .with(working_quote_params)
      .returns(stub(result: true))
    assert VertexClient.tax_area(working_quote_params)
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
      assert_equal logger, VertexClient.circuit.circuit_options[:logger]
    end

    it 'opens the circuit' do
      VCR.use_cassette('circuit_breaker', allow_playback_repeats: true, match_requests_on: []) do

        VertexClient.configuration.circuit_config = {
          logger: FakeLogger.new
        }

        # 'Not Open' means that we are actively hitting the service.
        VertexClient.configuration.trusted_id  = '💩'
        refute VertexClient.circuit.open?

        # Exhaust the configured volume threshold to open the circuit.
        # 'Open' means that we aren't going to connect to the service.
        threads = []
        (VertexClient::Configuration::CIRCUIT_CONFIG[:volume_threshold] + 1).times do
          threads << Thread.new { VertexClient.quotation(working_quote_params) }
        end
        threads.each(&:join)

        assert VertexClient.circuit.open?
        assert_kind_of VertexClient::Response::QuotationFallback, VertexClient.quotation(working_quote_params)
      end
    end
  end
end
