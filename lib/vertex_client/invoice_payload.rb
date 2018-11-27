module VertexClient
  class InvoicePayload < Payload

    NAME = 'invoice'.freeze

    def initialize(input)
      super(input)
      validate!
    end

    def validate!
      raise VertexClient::Error.new('document_number is required for invoice') if document_number_missing?
      raise VertexClient::Error.new('document_number must be less than or equal to 40 characters') if document_number_too_long?
    end

    def document_number_missing?
      @input[:document_number].to_s.empty?
    end

    def document_number_too_long?
      @input[:document_number].to_s.length > 40
    end

    def init_hash
      super.merge({
        :'@documentNumber' => @input[:document_number],
        :'@documentDate'   => @input[:date]
      })
    end

  end
end
