require 'test_helper'

describe VertexClient::Response::LineItemProduct do

  include TestInput

  let(:product_input_hash) do
    {
      :'content!'     =>  '4600',
    }
  end

  it 'initialized from an input hash' do
    product = VertexClient::Response::LineItemProduct.new(product_input_hash)
    assert_equal '4600', product.product_code
  end

  it 'initializes with a Nori::StringWithAttributes when we are looking at a response' do
    product = VertexClient::Response::LineItemProduct.new(fake_product_response)
    assert_equal '4600',    product.product_code
    assert_equal '1337',    product.product_class
  end
end
