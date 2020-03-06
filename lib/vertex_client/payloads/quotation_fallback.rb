# frozen_string_literal: true

require_relative 'quotation'

module VertexClient
  module Payloads
    class QuotationFallback < Quotation
      private

      def transform_customer(customer_params)
        customer_without_tax_area = customer_params.dup
        customer_without_tax_area.delete(:tax_area_id) if customer_without_tax_area[:tax_area_id].present?

        super(customer_without_tax_area)
      end
    end
  end
end
