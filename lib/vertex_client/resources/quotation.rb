# frozen_string_literal: true

require_relative 'base'
require_relative '../payloads/quotation_fallback'
require_relative '../responses/quotation_fallback'

module VertexClient
  module Resources
    class Quotation < Base
      ENDPOINT = 'CalculateTax70'

      def fallback_response
        fallback_payload = Payloads::QuotationFallback.new(@payload.params)
        Responses::QuotationFallback.new(fallback_payload)
      end
    end
  end
end
