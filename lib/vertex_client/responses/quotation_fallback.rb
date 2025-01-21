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
        @total_tax ||= line_items.sum(&:total_tax).to_d.round(2, :half_even)
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

      # see lib/vertex_client/rates.rb for hard-coded fallback rates
      def tax_amount(price, country, state)
        if domestic?(country) && state.present? && RATES['US'].has_key?(state)
          price * BigDecimal(RATES['US'][state])
        elsif !domestic?(country) && country.present? && RATES.has_key?(country)
          price * BigDecimal(RATES[country])
        else
          BigDecimal('0.0')
        end
      end

      def domestic?(country)
        # we assume a country-less customer is from the US
        country.nil? || country == 'US'
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
