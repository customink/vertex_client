# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/distribute_tax'

describe VertexClient::Responses::DistributeTax do
  subject { VertexClient::Responses::DistributeTax.new(vertex_quotation_response) }

  let(:vertex_quotation_response) do
    OpenStruct.new(
      body: {
        vertex_envelope: {
          distribute_tax_response: {
            total_tax: '6.0',
            total: '106.0',
            sub_total: '100.0'
          }
        }
      }
    )
  end

  it 'returns the correct total_tax' do
    assert_equal 6.0, subject.total_tax.to_f
  end

  it 'returns the correct total' do
    assert_equal 106.0, subject.total.to_f
  end

  it 'returns the correct subtotal' do
    assert_equal 100.0, subject.subtotal.to_f
  end
end
