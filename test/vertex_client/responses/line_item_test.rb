# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/line_item'

describe VertexClient::Responses::LineItem do
  include TestInput

  subject { VertexClient::Responses::LineItem.new(response_line_item) }

  let(:response_line_item) { { total_tax: '6.0', quantity: '1', price: '100', product: 'test' } }

  describe 'initialization from a Hash' do
    it 'returns the correct total tax' do
      assert_equal response_line_item[:total_tax].to_d, subject.total_tax
    end

    it 'returns the correct quantity' do
      assert_equal response_line_item[:quantity].to_f, subject.quantity
    end

    it 'returns the correct price' do
      assert_equal response_line_item[:price].to_d, subject.price
    end

    it 'returns the correct product' do
      assert_equal response_line_item[:product], subject.product
    end
  end

  describe 'initialization from nil params' do
    subject { VertexClient::Responses::LineItem.new({}) }

    it 'defaults the quantity to zero' do
      assert subject.quantity.zero?
    end

    it 'defaults the price to zero' do
      assert subject.price.zero?
    end

    it 'defaults the total tax to zero' do
      assert subject.total_tax.zero?
    end
  end
end
