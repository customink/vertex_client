require "test_helper"

describe VertexClient::Response::Quotation do
  before do
    @vertex_response = OpenStruct.new(:body => {
      vertex_envelope: {
        quotation_response: {
          total_tax: '6.0',
          total: '106.0',
          sub_total: '100.0',
          line_item: [
            {
              total_tax: '6.0',
              product: '4600'
            }
          ]
        }
      }
    })
    @response = VertexClient::Response::Quotation.new(@vertex_response)
  end

  it 'has attributes' do
    assert_equal @response.total_tax, BigDecimal.new('6.0')
    assert_equal @response.total, BigDecimal.new('106.0')
    assert_equal @response.subtotal, BigDecimal.new('100.0')
    assert_kind_of VertexClient::Response::LineItem, @response.line_items.first
  end
end
