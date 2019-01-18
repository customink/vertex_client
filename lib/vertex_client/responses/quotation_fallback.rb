module VertexClient
  module Response
    class QuotationFallback < Quotation

      def initialize(payload)
        @body = payload.body
      end

      def subtotal
        @subtotal || line_items.sum(&:price)
      end

      def total_tax
        @total_tax ||= line_items.sum(&:total_tax)
      end

      def total
        @total ||= subtotal + total_tax
      end

      private

      def tax_amount(price, state)
        if RATES.has_key?(state)
          price * BigDecimal.new(RATES[state])
        else
          BigDecimal.new("0.0")
        end
      end

      def tax_for_line_item(line_item)
        price = BigDecimal.new(line_item[:extended_price].to_s)
        state = line_item[:customer][:destination][:main_division]
        tax_amount(price, state)
      end

      def product_for_line_item(line_item)
        line_item[:product][:content!]
      end
    end
  end
end
