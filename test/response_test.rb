require "test_helper"

describe VertexClient::Response do
  before do
    @response = VertexClient::Response.new(
      vertex_envelope: {
        quotation_response: {
          total_tax: '6.0',
          total: '106.0',
          sub_total: '100.0'
        }
      }
    )
  end

  it 'has attributes' do
    assert_equal @response.total_tax, BigDecimal.new('6.0')
    assert_equal @response.total, BigDecimal.new('106.0')
    assert_equal @response.subtotal, BigDecimal.new('100.0')
  end
end
