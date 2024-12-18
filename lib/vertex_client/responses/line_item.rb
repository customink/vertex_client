module VertexClient
  module Response
    class LineItem

      attr_reader :total_tax, :product, :quantity, :price, :flexible_code_field

      def initialize(params={})
        @product        = params[:product]
        @quantity       = params[:quantity] ? params[:quantity].to_i : 0
        @price          = BigDecimal(params[:price] || 0)
        @total_tax      = BigDecimal(params[:total_tax] || 0)
        @flexible_code_field = params[:flexible_code_field]
      end
    end
  end
end
