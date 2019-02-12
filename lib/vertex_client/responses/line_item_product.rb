module VertexClient
  module Response
    class LineItemProduct

      attr_reader :product_code, :product_class

      def initialize(params)
        if params.is_a?(Nori::StringWithAttributes)
          @product_code   = params
          @product_class  = params.attributes['productClass']
        else
          @product_code   = params[:content!]
          @product_class  = params[:@productClass]
        end
      end
    end
  end
end
