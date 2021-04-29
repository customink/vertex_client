module VertexClient
  module Payload
    class Quotation < Base

      SALE_TRANSACTION_TYPE = 'SALE'.freeze

      def validate!
        raise VertexClient::ValidationError.new('customer requires either state or country and postal_code') if customer_missing_location?
        raise VertexClient::ValidationError.new('seller\'s physical_origin requires either state or country and postal_code') if sellers_physical_origin_missing_location?
      end

      def body
        {}.tap do |data|
          data[:'@transactionType'] = SALE_TRANSACTION_TYPE
          data[:'@isTaxOnlyAdjustmentIndicator'] = true if params[:tax_only_adjustment]
          data[:'@deliveryTerm'] = params[:delivery_term] if params[:delivery_term]
          data[:line_item] = params[:line_items].map.with_index do |line_item, index|
            transform_line_item(line_item, index, params)
          end
        end
      end

      private

      def customer_missing_location?
        !customer_lines(params).all? { |customer| destination_present?(customer) }
      end

      def sellers_physical_origin_missing_location?
        !sellers_physical_origin_lines(params).all? { |physical_origin| destination_present?(physical_origin) }
      end

      def transform_customer(customer_params)
        super(customer_params).tap do |customer|
          if customer_params[:tax_area_id].present?
            customer[:destination] = { :@taxAreaId => customer_params[:tax_area_id] }
          end
        end
      end

      def customer_lines(params)
        [params[:customer], params[:line_items].map { |li| li[:customer] }].flatten.compact
      end

      def sellers_physical_origin_lines(params)
        [params[:line_items].map { |li| li[:seller] && li[:seller][:physical_origin] }].flatten.compact
      end

      # The hash argument is either customer or physical_origin object
      def destination_present?(hash)
        us_location_present?(hash) || other_location_present?(hash)
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
        remove_nils({
          company: seller[:company],
          physical_origin: transform_address(seller[:physical_origin])
        })
      end

      def transform_product(line_item)
        {
          :'@productClass' => line_item[:product_class],
          :content! => line_item[:product_code]
        }
      end

      def us_location_present?(customer)
        customer[:state].present? && customer[:postal_code].present?
      end

      def other_location_present?(customer)
        customer[:country].present? && customer[:country] != 'US'
      end
    end
  end
end
