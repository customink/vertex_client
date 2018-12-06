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

  end
end
