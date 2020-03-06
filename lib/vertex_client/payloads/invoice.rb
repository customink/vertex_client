# frozen_string_literal: true

require_relative 'quotation'

module VertexClient
  module Payloads
    class Invoice < Quotation
      DOCUMENT_NUMBER_LIMIT = 40
      TOO_LONG_ERROR = "document_number must be less than or equal to #{DOCUMENT_NUMBER_LIMIT} characters"

      def validate!
        super

        raise VertexClient::ValidationError, 'document_number is required for invoice' if document_number_missing?
        raise VertexClient::ValidationError, TOO_LONG_ERROR if document_number_too_long?
      end

      def body
        super.merge('@documentNumber': params[:document_number], '@documentDate': params[:date])
      end

      def document_number_missing?
        params[:document_number].to_s.empty?
      end

      def document_number_too_long?
        params[:document_number].to_s.length > DOCUMENT_NUMBER_LIMIT
      end
    end
  end
end
