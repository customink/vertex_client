module VertexClient
  module Resource
    class Quotation < Base
      ENDPOINT = 'CalculateTax70'.freeze

      def fallback_response
        Response::QuotationFallback.new(@payload)
      end
    end
  end
end
