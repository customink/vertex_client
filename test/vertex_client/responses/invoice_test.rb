# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/invoice'

describe VertexClient::Responses::Invoice do
  include TestInput

  subject { VertexClient::Responses::Invoice.new(vertex_quotation_response) }

  let(:vertex_quotation_response) do
    OpenStruct.new(
      body: {
        vertex_envelope: {
          invoice_response: {
            total_tax: '6.0',
            total: '106.0',
            sub_total: '100.0',
            line_item: [
              {
                quantity: '1',
                extended_price: '100',
                total_tax: '6.0',
                product: fake_product_response
              }
            ]
          }
        }
      }
    )
  end

  describe 'Attributes' do
    let(:line_item) { subject.line_items.first }

    it 'returns the correct total_tax' do
      assert_equal 6.0, subject.total_tax.to_f
    end

    it 'returns the correct total' do
      assert_equal 106.0, subject.total.to_f
    end

    it 'returns the correct subtotal' do
      assert_equal 100.0, subject.subtotal.to_f
    end

    it 'returns the correct type of line items' do
      assert(subject.line_items.all? { |line_item| line_item.is_a?(VertexClient::Responses::LineItem) })
    end

    it 'returns the correct amount of line items' do
      assert_equal 1, subject.line_items.size
    end

    it 'returns the correct product code for the line item' do
      assert_equal '4600', line_item.product.product_code
    end

    it 'returns the correct product class for the line item' do
      assert_equal '1337', line_item.product.product_class
    end

    it 'returns the correct quantity for the line item' do
      assert_equal 1, line_item.quantity
    end

    it 'returns the correct price for the line item' do
      assert_equal 100.0, line_item.price.to_f
    end
  end
end
