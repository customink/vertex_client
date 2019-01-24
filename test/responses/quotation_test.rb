require "test_helper"

describe VertexClient::Response::Quotation do
  let(:vertex_quotation_response) do
    OpenStruct.new(body: {
      vertex_envelope: {
        quotation_response: {
          total_tax: '6.0',
          total: '106.0',
          sub_total: '100.0',
          line_item: [
            {
              quantity: '1',
              price: '100',
              total_tax: '6.0',
              product: '4600'
            }
          ]
        }
      }
    })
  end

  let(:response) { VertexClient::Response::Quotation.new(vertex_quotation_response) }

  it 'has attributes' do
    assert_equal 6.0,   response.total_tax.to_f
    assert_equal 106.0, response.total.to_f
    assert_equal 100.0, response.subtotal.to_f
    assert_kind_of VertexClient::Response::LineItem, response.line_items.first
  end
end
