require 'test_helper'

describe VertexClient::Resource::TaxArea do
  include TestInput

  let(:resource) do
    VertexClient::Resource::TaxArea.new(
      test: :ok
    )
  end

  it 'has an ENDPOINT' do
    assert_equal 'LookupTaxAreas70', VertexClient::Resource::TaxArea::ENDPOINT
  end

  it 'has a fallback_response' do
    assert_kind_of VertexClient::Response::TaxAreaFallback, resource.fallback_response
  end

  it 'has a config_key' do
    assert_equal :tax_area, resource.config_key
  end
end
