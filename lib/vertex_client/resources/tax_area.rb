module VertexClient
  module Resource
    class TaxArea < Base
      ENDPOINT = 'LookupTaxAreas70'.freeze
      def fallback_response
        Response::TaxAreaFallback.new
      end
    end
  end
end
