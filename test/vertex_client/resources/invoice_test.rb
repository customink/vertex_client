# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/resources/invoice'

describe VertexClient::Resources::Invoice, :vcr do
  include TestInput

  subject { VertexClient::Resources::Invoice.new(working_quote_params) }

  it 'has an ENDPOINT' do
    assert_equal 'CalculateTax70', VertexClient::Resources::Invoice::ENDPOINT
  end

  describe '#result' do
    it 'raises when there is no response' do
      subject.stubs(response: nil)

      assert_raises VertexClient::ServerError do
        subject.result
      end
    end

    it 'returns data from the Vertex Service' do
      refute_nil subject.result
    end

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::Invoice, subject.result
    end
  end

  describe '#config_key' do
    it 'has a config_key' do
      assert_equal :invoice, subject.config_key
    end
  end
end
