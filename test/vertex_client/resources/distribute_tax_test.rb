# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/resources/distribute_tax'

describe VertexClient::Resources::DistributeTax, :vcr do
  include TestInput

  subject { VertexClient::Resources::DistributeTax.new(distribute_tax_params) }

  it 'has an ENDPOINT' do
    assert_equal 'CalculateTax70', VertexClient::Resources::DistributeTax::ENDPOINT
  end

  describe '#result' do
    it 'raises when there is no response' do
      subject.stubs(response: nil)
      assert_raises VertexClient::ServerError do
        subject.result
      end
    end

    it 'returns valid data from the Vertex Service' do
      refute_nil subject.result
    end

    it 'returns the correct response object' do
      assert_kind_of VertexClient::Responses::DistributeTax, subject.result
    end
  end

  describe '#config_key' do
    it 'has a config_key' do
      assert_equal :distribute_tax, subject.config_key
    end
  end
end
