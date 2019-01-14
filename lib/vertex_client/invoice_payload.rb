module VertexClient
  class InvoicePayload < Payload

    NAME = 'invoice'.freeze
    VALIDATIONS = [:location, :document_number].freeze

    def init_hash
      super.merge({
        :'@documentNumber' => @input[:document_number],
        :'@documentDate'   => @input[:date]
      })
    end

    def fallback_response
      false
    end
  end
end
