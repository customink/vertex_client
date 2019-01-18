module VertexClient
  module Response
    class TaxArea < Base
      def tax_area_id
        @tax_area_id ||= @body[:tax_area_result][:@tax_area_id]
      end
    end
  end
end
