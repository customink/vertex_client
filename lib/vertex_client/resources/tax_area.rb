# frozen_string_literal: true

require_relative 'base'
require_relative '../responses/tax_area_fallback'
require_relative '../responses/tax_area'
require_relative '../payloads/tax_area'

module VertexClient
  module Resources
    class TaxArea < Base
      ENDPOINT = 'LookupTaxAreas70'

      def fallback_response
        Responses::TaxAreaFallback.new
      end
    end
  end
end
