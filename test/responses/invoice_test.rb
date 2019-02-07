require "test_helper"

describe VertexClient::Response::Invoice do
  let(:vertex_quotation_response) do
    OpenStruct.new(body: {
      vertex_envelope: {
        invoice_response: {
          total_tax: '6.0',
          total: '106.0',
          sub_total: '100.0',
          line_item: [
            {
              quantity: '1',
              extended_price: '100',
              total_tax: '6.0',
              product: '4600'
            }
          ]
        }
      }
    })
  end

  let(:response) { VertexClient::Response::Invoice.new(vertex_quotation_response) }

  it 'has attributes' do
    assert_equal 6.0,   response.total_tax.to_f
    assert_equal 106.0, response.total.to_f
    assert_equal 100.0, response.subtotal.to_f
    assert_kind_of VertexClient::Response::LineItem, response.line_items.first
  end

  describe 'line_items' do
    it 'is a collection of Response::LineItem' do
      assert_equal 1,       response.line_items.size
      assert_equal '4600',  response.line_items.first.product.product_code
      assert_equal 1,       response.line_items.first.quantity
      assert_equal 100.0,   response.line_items.first.price.to_f
    end
  end
end
