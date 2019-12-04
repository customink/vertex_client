module VertexClient
  module Payload
    class Quotation < Base

      SALE_TRANSACTION_TYPE = 'SALE'.freeze

      def validate!
        raise VertexClient::ValidationError.new('customer requires a state and postal_code') if customer_missing_location?
      end

      def body
        {
          :'@transactionType' => SALE_TRANSACTION_TYPE,
          line_item: params[:line_items].map.with_index do |line_item, index|
            transform_line_item(line_item, index, params)
          end
        }
      end

      private

      def customer_missing_location?
        !customer_lines(params).all? { |customer| customer_destination_present?(customer) }
      end

      def transform_customer(customer_params)
        super(customer_params).tap do |customer|
          if customer_params[:tax_area_id].present?
            customer[:destination] = { :@taxAreaId => customer_params[:tax_area_id]}
          end
        end
      end

      def customer_lines(params)
        [params[:customer], params[:line_items].map { |li| li[:customer]}].flatten.compact
      end

      def customer_destination_present?(customer)
        (customer[:state].present? || customer[:country].present?) && customer[:postal_code].present?
      end

      def transform_line_item(line_item, number, defaults)
        remove_nils({
          :'@lineItemNumber' => number+1,
          :'@taxDate' =>  line_item[:date] || defaults[:date],
          :'@locationCode' => line_item[:location_code] || defaults[:location_code],
          customer:       transform_customer(line_item[:customer] || defaults[:customer]),
          seller:         transform_seller(line_item[:seller] || defaults[:seller]),
          product:        transform_product(line_item),
          quantity:       line_item[:quantity],
          extended_price: line_item[:price],
        })
      end

      def transform_seller(seller)
        {
          company: seller[:company]
        }
      end

      def transform_product(line_item)
        {
          :'@productClass' => line_item[:product_class],
          :content! => line_item[:product_code]
        }
      end
    end
  end
end
