# frozen_string_literal: true

module VertexClient
  module Responses
    class QuotationFallback < Quotation
      def initialize(payload)
        @body = payload.body
      end

      def subtotal
        @subtotal || line_items.sum(&:price)
      end

      def total_tax
        @total_tax ||= line_items.sum(&:total_tax).floor(2)
      end

      def total
        @total ||= subtotal + total_tax
      end

      private

      def product_for_line_item(product)
        LineItemProduct.new(
          product_code: product[:content!],
          product_class: product[:@productClass]
        )
      end

      def tax_amount(price, state)
        if RATES.key?(state)
          price * BigDecimal(RATES[state])
        else
          BigDecimal('0.0')
        end
      end

      def tax_for_line_item(line_item)
        price = BigDecimal(line_item[:extended_price].to_s)
        state = line_item[:customer][:destination][:main_division]
        tax_amount(price, state)
      end
    end
  end
end
