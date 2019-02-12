require 'test_helper'

describe VertexClient::Response::Quotation do

 include TestInput

  let(:vertex_quotation_response) do
    OpenStruct.new(body: {
      vertex_envelope: {
        quotation_response: {
          total_tax: '6.0',
          total: '106.0',
          sub_total: '100.0',
          line_item: [
            {
              quantity: '1',
              extended_price: '100',
              total_tax: '6.0',
              product: fake_product_response('4600', '1234')
            }
          ]
        }
      }
    })
  end

  let(:empty_product_response) do
    parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
    lip = parser.parse('<product productClass="my_awesome_class" />')
    resp = vertex_quotation_response.dup
    resp.body[:vertex_envelope][:quotation_response][:line_item] = [lip]
    resp
  end

  let(:response) { VertexClient::Response::Quotation.new(vertex_quotation_response) }

  it 'has attributes' do
    assert_equal 6.0,   response.total_tax.to_f
    assert_equal 106.0, response.total.to_f
    assert_equal 100.0, response.subtotal.to_f
    assert_kind_of VertexClient::Response::LineItem, response.line_items.first
    assert_kind_of VertexClient::Response::LineItemProduct, response.line_items.first.product
  end

  describe 'line_items' do
    it 'is a collection of Response::LineItem' do
      assert_equal 1,       response.line_items.size
      assert_equal '4600',  response.line_items.first.product.product_code
      assert_equal '1234',  response.line_items.first.product.product_class
      assert_equal 1,       response.line_items.first.quantity
      assert_equal 100.0,   response.line_items.first.price.to_f
      assert_equal 6.0,     response.line_items.first.total_tax.to_f
    end

    it 'parses products that do not have text values/product_codes' do
      alt_response = VertexClient::Response::Quotation.new(empty_product_response)
      assert_nil alt_response.line_items.first.product.product_code
      assert_equal 'my_awesome_class', alt_response.line_items.first.product.product_class
    end
  end
end
