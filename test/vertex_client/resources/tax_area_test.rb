# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/resources/tax_area'

describe VertexClient::Resources::TaxArea, :vcr do
  include TestInput

  subject { VertexClient::Resources::TaxArea.new(test: :ok) }

  it 'has an ENDPOINT' do
    assert_equal 'LookupTaxAreas70', VertexClient::Resources::TaxArea::ENDPOINT
  end

  describe '#fallback_response' do
    it 'has a fallback_response' do
      assert_kind_of VertexClient::Responses::TaxAreaFallback, subject.fallback_response
    end
  end

  describe '#config_key' do
    it 'has a config_key' do
      assert_equal :tax_area, subject.config_key
    end
  end

  describe '#result' do
    it 'returns a TaxAreaFallback response if the service errors out' do
      subject.stubs(response: nil)

      assert_kind_of(VertexClient::Responses::TaxAreaFallback, subject.result)
    end

    it 'returns a TaxArea response if the service works' do
      assert_kind_of(VertexClient::Responses::TaxArea, subject.result)
    end
  end
end
