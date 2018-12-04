require "test_helper"

describe VertexClient::ResponseLineItem do
  let(:reponse_line_item) do
    {
      total_tax: '6.0',
      product: '4600',
      quantity: '1',
      extended_price: '100'
    }
  end

  it 'initializes from the response hash' do
    item = VertexClient::ResponseLineItem.init_from_hash(reponse_line_item)
    assert_equal BigDecimal.new('6.0'), item.total_tax
    assert_equal reponse_line_item[:product], item.product_code
    assert_equal reponse_line_item[:quantity], item.quantity
    assert_equal reponse_line_item[:extended_price], item.price
  end
end
