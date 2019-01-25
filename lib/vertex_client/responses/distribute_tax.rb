module VertexClient
  module Response
    class DistributeTax < Base
      def subtotal
        @subtotal ||= BigDecimal.new(@body[:sub_total])
      end

      def total_tax
        @total_tax ||= BigDecimal.new(@body[:total_tax])
      end

      def total
        @total ||= BigDecimal.new(@body[:total])
      end
    end
  end
end
