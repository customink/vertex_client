require "test_helper"

describe VertexClient::Response do
  before do
    @response = VertexClient::Response.new({
      total_tax: '6.0',
      total: '106.0',
      sub_total: '100.0',
      line_item: {
        total_tax: '6.0',
        product: '4600'
      }
    })
  end

  it 'has attributes' do
    assert_equal @response.total_tax, BigDecimal.new('6.0')
    assert_equal @response.total, BigDecimal.new('106.0')
    assert_equal @response.subtotal, BigDecimal.new('100.0')
    assert_kind_of VertexClient::ResponseLineItem, @response.line_items.first
  end
end
