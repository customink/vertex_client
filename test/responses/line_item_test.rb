require "test_helper"

describe VertexClient::Response::LineItem do
  let(:response_line_item) do
    {
      total_tax:  '6.0',
      product:    '4600',
      quantity:   '1',
      price:      '100'
    }
  end

  it 'initializes from the response hash' do
    item = VertexClient::Response::LineItem.new(response_line_item)
    assert_equal response_line_item[:total_tax].to_d, item.total_tax
    assert_equal response_line_item[:product],        item.product
    assert_equal response_line_item[:quantity].to_f,  item.quantity
    assert_equal response_line_item[:price].to_d,     item.price
  end

  it 'is safe about assignment and casting of nil params' do
    item = VertexClient::Response::LineItem.new({})
    assert_equal 0, item.quantity
    assert_equal 0, item.price
    assert_equal 0, item.total_tax
  end
end
