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
        @total_tax ||= line_items.sum(&:total_tax).round(2, :half_even)
      end

      def total
        @total ||= subtotal + total_tax
      end

      private

      def product_for_line_item(product)
        LineItemProduct.new(
          product_code:   product[:content!],
          product_class:  product[:@productClass],
        )
      end

      def tax_amount(price, country, state)
        if state.present? && RATES['USA'].has_key?(state)
          price * BigDecimal(RATES['USA'][state])
        elsif country.present? && RATES['EU'].has_key?(country)
          price * BigDecimal(RATES['EU'][country])
        else
          BigDecimal('0.0')
        end
      end

      def tax_for_line_item(line_item)
        price = BigDecimal(line_item[:extended_price].to_s)
        state = line_item[:customer][:destination][:main_division]
        country = line_item[:customer][:destination][:country]
        tax_amount(price, country, state)
      end
    end
  end
end
