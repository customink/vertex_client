require 'test_helper'

describe VertexClient::Response::LineItemProduct do

  include TestInput

  it 'initializes' do
    product = VertexClient::Response::LineItemProduct.new(
      product_class:  fake_product_response.attributes['productClass'],
      product_code:   fake_product_response.to_s
    )
    assert_equal '4600',    product.product_code
    assert_equal '1337',    product.product_class
  end
end
