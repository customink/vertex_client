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
      VertexClient.quotation(working_quote_params)
    end
  end

  it 'uses circuit if it is available' do
    VertexClient.configuration.circuit_config = {}
    VCR.use_cassette("quotation", :match_requests_on => []) do
      VertexClient.quotation(working_quote_params)
    end
  end

  it 'does an invoice' do
    VCR.use_cassette("invoice", :match_requests_on => []) do
      VertexClient.invoice(working_quote_params)
    end
  end
end
