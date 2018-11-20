require "test_helper"

describe VertexClient::Connection do
  include TestInput

  it 'does a quotation' do
    VertexClient.reconfigure!
    VCR.use_cassette("quotation", :match_requests_on => []) do
      VertexClient.quotation(test_input)
    end
  end
end
