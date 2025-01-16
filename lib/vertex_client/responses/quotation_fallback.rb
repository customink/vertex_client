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
        if known_us_state?(country, state)
          price * BigDecimal(RATES['US'][state])
        elsif known_non_us_country?(country)
          price * BigDecimal(RATES[country])
        else
          BigDecimal('0.0')
        end
      end

      # state is in the United States and we have an explicit fallback
      def known_us_state?(country, state)
        return false if country.present? && country != 'US'

        state.present? && RATES['US'].has_key?(state)
      end

      # we have an explicit fallback for the country
      def known_non_us_country?(country)
        country.present? && country != 'US' && RATES.has_key?(country)
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
