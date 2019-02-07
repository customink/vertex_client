require 'test_helper'

describe VertexClient::Response::LineItemProduct do
  let(:product_attributes) do
    {
      :'content!'     =>  '4600',
      :@productClass  =>  '1234'
    }
  end

  it 'initializes from the a product hash' do
    product = VertexClient::Response::LineItemProduct.new(product_attributes)
    assert_equal '4600', product.product_code
    assert_equal '1234', product.product_class
  end

  it 'initializes with a string, too' do
    product = VertexClient::Response::LineItemProduct.new('4601')
    assert_equal '4601', product.product_code
  end
end
