module VertexClient
  module Response
    class LineItem

      attr_reader :total_tax, :product, :quantity, :price

      def initialize(params={})
        @product        = LineItemProduct.new(params[:product] || {})
        @quantity       = params[:quantity] ? params[:quantity].to_i : 0
        @price          = BigDecimal.new(params[:price] || 0)
        @total_tax      = BigDecimal.new(params[:total_tax] || 0)
      end
    end
  end
end
