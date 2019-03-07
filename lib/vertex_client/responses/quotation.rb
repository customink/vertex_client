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
        @line_items ||= normalized_line_items.map do |line_item|
          LineItem.new(
            product:        product_for_line_item(line_item[:product]),
            quantity:       line_item[:quantity],
            price:          line_item[:extended_price],
            total_tax:      tax_for_line_item(line_item)
          )
        end
      end

      private

      def product_for_line_item(product)
        if(product).is_a?(Nori::StringWithAttributes)
          LineItemProduct.new(
            product_code:   product.to_s,
            product_class:  product.attributes['productClass'],
          )
        else
          LineItemProduct.new(
            product_code:   product['@product_code'],
            product_class:  product['@product_class'],
          )
        end
      end

      def tax_for_line_item(line_item)
        line_item[:total_tax]
      end

      def normalized_line_items
        [ @body[:line_item] ].flatten
      end
    end
  end
end
