module VertexClient
  module Response
    class DistributeTax < Base
      def subtotal
        @subtotal ||= BigDecimal(@body[:sub_total])
      end

      def total_tax
        @total_tax ||= BigDecimal(@body[:total_tax])
      end

      def total
        @total ||= BigDecimal(@body[:total])
      end
    end
  end
end
