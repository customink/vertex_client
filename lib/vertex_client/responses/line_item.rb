module VertexClient
  module Response
    class LineItem

      attr_reader :total_tax, :product_code, :quantity, :price

      def initialize(params={})
        @product_code   = params[:product_code]
        @quantity       = params[:quantity].to_i
        @price          = BigDecimal.new(params[:price])
        @total_tax      = BigDecimal.new(params[:total_tax] || '0.0')
      end
    end
  end
end
