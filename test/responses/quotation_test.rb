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
    assert_equal response.total_tax, BigDecimal.new('6.0')
    assert_equal response.total, BigDecimal.new('106.0')
    assert_equal response.subtotal, BigDecimal.new('100.0')
    assert_kind_of VertexClient::Response::LineItem, response.line_items.first
  end
end
