# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/resources/quotation'
require 'vertex_client/responses/quotation_fallback'

describe VertexClient::Resources::Quotation, :vcr do
  include TestInput

  subject { VertexClient::Resources::Quotation.new(working_quote_params) }

  it 'has an ENDPOINT' do
    assert_equal 'CalculateTax70', VertexClient::Resources::Quotation::ENDPOINT
  end

  describe '#fallback_response' do
    it 'has a fallback_response' do
      assert_kind_of VertexClient::Responses::QuotationFallback, subject.fallback_response
    end
  end

  describe '#config_key' do
    it 'has a config_key' do
      assert_equal :quotation, subject.config_key
    end
  end

  describe '#result' do
    it 'returns a fallback response if the Vertex Service errors out' do
      subject.stubs(response: nil)

      assert_kind_of(VertexClient::Responses::QuotationFallback, subject.result)
    end

    it "returns a Quotation response if the Vertex Service doesn't error out" do
      assert_kind_of(VertexClient::Responses::Quotation, subject.result)
    end
  end
end
