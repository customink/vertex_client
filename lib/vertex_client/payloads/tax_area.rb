module VertexClient
  module Payload
    class TaxArea < Base

      def validate!
        raise VertexClient::ValidationError.new('At least give a value') if values_empty?
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
