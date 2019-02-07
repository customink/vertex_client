module VertexClient
  module Response
    class Quotation < Base

      def subtotal
        @subtotal ||= BigDecimal.new(@body[:sub_total])
      end

      def total_tax
        @total_tax ||= BigDecimal.new(@body[:total_tax])
      end

      def total
        @total ||= BigDecimal.new(@body[:total])
      end

      def line_items
        @line_items ||= @body[:line_item].flatten.map do |line_item|
          LineItem.new(
            product:        line_item[:product],
            quantity:       line_item[:quantity],
            price:          line_item[:extended_price],
            total_tax:      tax_for_line_item(line_item)
          )
        end
      end

      private

      def tax_for_line_item(line_item)
        line_item[:total_tax]
      end
    end
  end
end
