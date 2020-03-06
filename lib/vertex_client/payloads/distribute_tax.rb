# frozen_string_literal: true

require_relative 'invoice'

module VertexClient
  module Payloads
    class DistributeTax < Invoice
      def validate!
        super

        return if all_line_items_have_tax?

        raise VertexClient::ValidationError, 'total_tax must be specified for all line items'
      end

      def all_line_items_have_tax?
        params[:line_items].all? { |item| item[:total_tax].present? }
      end

      def transform_line_item(line_item, number, defaults)
        remove_nils(super(line_item, number, defaults).merge(
                      input_total_tax: line_item[:total_tax]
                    ))
      end
    end
  end
end
