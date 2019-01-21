module VertexClient
  module Response
    class LineItem

      attr_reader :total_tax, :product, :quantity, :price

      def initialize(params={})
        @product        = params[:product]
        @quantity       = params[:quantity]   && params[:quantity].to_i
        @price          = params[:price]      && BigDecimal.new(params[:price])
        @total_tax      = params[:total_tax]  && BigDecimal.new(params[:total_tax])
      end
    end
  end
end
