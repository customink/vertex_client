module VertexClient
  module Resource
    class Quotation < Base
      ENDPOINT = 'CalculateTax70'.freeze

      def fallback_response
        fallback_payload = Payload::QuotationFallback.new(@payload.params)
        Response::QuotationFallback.new(fallback_payload)
      end
    end
  end
end
