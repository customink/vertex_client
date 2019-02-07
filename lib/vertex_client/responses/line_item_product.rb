module VertexClient
  module Response
    class LineItemProduct

      attr_reader :product_code, :product_class

      def initialize(params)
        if params.is_a?(Hash)
          @product_code   = params[:content!]
        else
          @product_code   = params
        end
      end
    end
  end
end
