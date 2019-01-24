require "test_helper"

describe VertexClient::Response::QuotationFallback do
  include TestInput

  let(:payload) { VertexClient::Payload::QuotationFallback.new(working_quote_params) }
  let(:response) { VertexClient::Response::QuotationFallback.new(payload) }

  it 'initializes @body with payload.body' do
    assert_equal payload.body, response.instance_variable_get(:@body)
  end

  describe 'subtotal' do
    it 'is the sum of price from line_items' do
      assert_equal 60.9, response.subtotal.to_f
    end
  end

  describe 'total_tax' do
    it 'is the sum of total_tax from line_items' do
      assert_equal  1.77, response.total_tax.to_f
    end
  end

  describe 'total' do
    it 'is the sum of subtotal and total_tax' do
      assert_equal 62.67, response.total.to_f
    end
  end

  describe 'line_items' do
    it 'is a collection of Response::LineItem' do
      assert_equal 2,       response.line_items.size
      assert_equal '4600',  response.line_items.first.product
      assert_equal 7,       response.line_items.first.quantity
      assert_equal 35.5,    response.line_items.first.price.to_f
    end
  end
end
