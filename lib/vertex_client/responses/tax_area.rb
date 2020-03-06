# frozen_string_literal: true

module VertexClient
  module Responses
    class TaxArea < Base
      def tax_area_id
        @tax_area_id ||= primary_result[:@tax_area_id]
      end

      private

      def primary_result
        return @body[:tax_area_result][0] if @body[:tax_area_result].is_a?(Array)

        @body[:tax_area_result]
      end
    end
  end
end
