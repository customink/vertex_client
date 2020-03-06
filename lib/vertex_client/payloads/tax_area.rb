# frozen_string_literal: true

require_relative 'base'

module VertexClient
  module Payloads
    class TaxArea < Base
      def validate!
        raise VertexClient::ValidationError, 'At least give a value' if values_empty?
      end

      def body
        {
          tax_area_lookup: {
            postal_address: transform_customer(params)[:destination]
          }
        }
      end

      def values_empty?
        params.values.all?(&:empty?)
      end
    end
  end
end
