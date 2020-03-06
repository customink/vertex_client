# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/quotation_fallback'
require 'vertex_client/payloads/quotation_fallback'

describe VertexClient::Responses::QuotationFallback do
  include TestInput

  subject { VertexClient::Responses::QuotationFallback.new(payload) }

  let(:payload) { VertexClient::Payloads::QuotationFallback.new(working_quote_params) }

  before { working_quote_params[:line_items].last[:price] = '100.0' }

  it 'initializes @body with payload.body' do
    assert_equal payload.body, subject.instance_variable_get(:@body)
  end

  describe '#subtotal' do
    it 'is the sum of price from line_items' do
      assert_equal 135.5, subject.subtotal.to_f
    end
  end

  describe '#total_tax' do
    it 'is the sum of total_tax from line_items' do
      assert_equal 8.66, subject.total_tax.to_f
    end
  end

  describe '#total' do
    it 'is the sum of subtotal and total_tax' do
      assert_equal 144.16, subject.total.to_f
    end
  end

  describe '#line_items' do
    let(:line_item) { subject.line_items.first }

    it 'returns the correct amount of line items' do
      assert_equal 2, subject.line_items.size
    end

    it 'returns the correct product code for the line item' do
      assert_equal '4600', subject.line_items.first.product.product_code
    end

    it 'returns the correct product class for the line item' do
      assert_equal '53103000', subject.line_items.first.product.product_class
    end

    it 'returns the correct quantity for the line item' do
      assert_equal 7, subject.line_items.first.quantity
    end

    it 'returns the correct price for the line item' do
      assert_equal 35.5, subject.line_items.first.price.to_f
    end
  end
end
