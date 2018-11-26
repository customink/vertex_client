require "test_helper"

describe VertexClient::Connection do
  include TestInput
  before do
    VertexClient.reconfigure!
  end

  after do
    VertexClient.reconfigure!
  end

  it 'does a quotation' do
    VCR.use_cassette("quotation", :match_requests_on => []) do
      VertexClient.quotation(test_input)
    end
  end

  it 'uses circuit if it is available' do
    VertexClient.configuration.circuit_config = {}
    VCR.use_cassette("quotation", :match_requests_on => []) do
      VertexClient.quotation(test_input)
    end
  end
end
