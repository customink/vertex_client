module VertexClient
  module Payload
    class Invoice < Quotation

      DOCUMENT_NUMBER_LIMIT = 40

      def validate!
        super
        raise VertexClient::ValidationError.new('document_number is required for invoice') if document_number_missing?
        raise VertexClient::ValidationError.new("document_number must be less than or equal to #{DOCUMENT_NUMBER_LIMIT} characters") if document_number_too_long?
      end

      def body
        b = super.merge({
          :'@documentNumber' => params[:document_number],
          :'@documentDate'   => params[:date]
        })
        b[:'@postingDate'] = params[:posting_date] if params[:posting_date].present?
        b
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
