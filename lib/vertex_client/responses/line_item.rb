# frozen_string_literal: true

module VertexClient
  module Responses
    class LineItem
      attr_reader :total_tax, :product, :quantity, :price

      def initialize(params = {})
        @product        = params[:product]
        @quantity       = params[:quantity] ? params[:quantity].to_i : 0
        @price          = BigDecimal(params[:price] || 0)
        @total_tax      = BigDecimal(params[:total_tax] || 0)
      end
    end
  end
end
