require 'test_helper'

describe VertexClient::Resource::Quotation do
  include TestInput

  let(:resource){ VertexClient::Resource::Quotation.new(working_quote_params) }

  it 'has an ENDPOINT' do
    assert_equal 'CalculateTax70', VertexClient::Resource::Quotation::ENDPOINT
  end

  it 'has a fallback_response' do
    assert_kind_of VertexClient::Response::QuotationFallback, resource.fallback_response
  end
end
