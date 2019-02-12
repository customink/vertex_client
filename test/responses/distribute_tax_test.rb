require 'test_helper'

describe VertexClient::Response::DistributeTax do
  let(:vertex_quotation_response) do
    OpenStruct.new(body: {
      vertex_envelope: {
        distribute_tax_response: {
          total_tax: '6.0',
          total: '106.0',
          sub_total: '100.0'
        }
      }
    })
  end

  let(:response) { VertexClient::Response::DistributeTax.new(vertex_quotation_response) }

  it 'has attributes' do
    assert_equal 6.0,   response.total_tax.to_f
    assert_equal 106.0, response.total.to_f
    assert_equal 100.0, response.subtotal.to_f
  end
end
