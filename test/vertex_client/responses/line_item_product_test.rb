# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/line_item_product'

describe VertexClient::Responses::LineItemProduct do
  include TestInput

  subject { VertexClient::Responses::LineItemProduct.new(product_class: product_class, product_code: product_code) }

  let(:product_class) { fake_product_response.attributes['productClass'] }
  let(:product_code) { fake_product_response.to_s }

  describe '#initialize' do
    it 'properly assigns the product code' do
      assert_equal product_code, subject.product_code
    end

    it 'properly assigns the product class' do
      assert_equal product_class, subject.product_class
    end
  end
end
