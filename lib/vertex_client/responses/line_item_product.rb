# frozen_string_literal: true

module VertexClient
  module Responses
    class LineItemProduct
      attr_reader :product_code, :product_class

      def initialize(params)
        @product_code   = params[:product_code]
        @product_class  = params[:product_class]
      end
    end
  end
end
