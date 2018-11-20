require "test_helper"

describe VertexClient::Response do
  before do
    @response = VertexClient::Response.new(
      vertex_envelope: {
        quotation_response: {
          total_tax: 6,
          total: 106,
          sub_total: 100
        }
      }
    )
  end

  it 'has attributes' do
    assert_equal @response.total_tax, 6
    assert_equal @response.total, 106
    assert_equal @response.subtotal, 100
  end
end
