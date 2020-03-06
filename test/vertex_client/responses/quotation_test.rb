# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/quotation'

describe VertexClient::Responses::Quotation do
  include TestInput

  subject { VertexClient::Responses::Quotation.new(vertex_quotation_response) }

  let(:vertex_quotation_response) do
    OpenStruct.new(
      body: {
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
      }
    )
  end
  let(:empty_product_response) do
    parser = Nori.new(convert_tags_to: ->(tag) { tag.snakecase.to_sym })
    lip = parser.parse('<product productClass="my_awesome_class" />')
    resp = vertex_quotation_response.dup
    resp.body[:vertex_envelope][:quotation_response][:line_item] = [lip]
    resp
  end
  let(:singular_line_item_response) { vertex_quotation_response.dup }

  describe 'Attributes' do
    it 'returns the correct total tax' do
      assert_equal 6.0, subject.total_tax.to_f
    end

    it 'returns the correct total' do
      assert_equal 106.0, subject.total.to_f
    end

    it 'returns the correct subtotal' do
      assert_equal 100.0, subject.subtotal.to_f
    end

    it 'returns the correct type of objects' do
      assert(subject.line_items.all? { |line_item| line_item.is_a?(VertexClient::Responses::LineItem) })
    end

    it 'returns the correct sub type of objects' do
      assert(subject.line_items.all? { |line_item| line_item.product.is_a?(VertexClient::Responses::LineItemProduct) })
    end
  end

  describe 'line_items' do
    let(:line_item) { subject.line_items.first }
    let(:empty_response) { VertexClient::Responses::Quotation.new(empty_product_response) }
    let(:single_response) { VertexClient::Responses::Quotation.new(singular_line_item_response) }

    it 'returns the correct amount of line items' do
      assert_equal 1, subject.line_items.size
    end

    it 'returns the correct product code for the line item' do
      assert_equal '4600', line_item.product.product_code
    end

    it 'returns the correct product class for the line item' do
      assert_equal '1234', line_item.product.product_class
    end

    it 'returns the correct quantity for the line item' do
      assert_equal 1, line_item.quantity
    end

    it 'returns the correct price for the line item' do
      assert_equal 100.0, line_item.price.to_f
    end

    it 'returns the correct total tax for the line item' do
      assert_equal 6.0, line_item.total_tax.to_f
    end

    it 'supports empty responses for the product code' do
      assert_nil empty_response.line_items.first.product.product_code
    end

    it 'supports empty responses for the product class' do
      assert_equal 'my_awesome_class', empty_response.line_items.first.product.product_class
    end

    it 'still returns a Line Item when the body is a single object' do
      assert_kind_of VertexClient::Responses::LineItem, single_response.line_items.first
    end

    it 'still returns a LineItemProduct when the body is a single object' do
      assert_kind_of VertexClient::Responses::LineItemProduct, single_response.line_items.first.product
    end
  end
end
