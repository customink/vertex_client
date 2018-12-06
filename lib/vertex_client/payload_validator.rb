module VertexClient
  class PayloadValidator

    DOCUMENT_NUMBER_LIMIT = 40

    def initialize(payload, validations=[])
      @payload = payload
      @validations = validations
    end

    def validate!
      @validations.each { |v| send(v) }
    end

    private

    def location
      raise VertexClient::PayloadValidationError.new('customer requires a state or postal_code') if customer_missing_location?
    end

    def document_number
      raise VertexClient::PayloadValidationError.new('document_number is required for invoice') if document_number_missing?
      raise VertexClient::PayloadValidationError.new("document_number must be less than or equal to #{DOCUMENT_NUMBER_LIMIT} characters") if document_number_too_long?
    end

    def customer_missing_location?
      !@payload.all_customer_lines.all? { |customer| state_or_postal_code?(customer) }
    end

    def state_or_postal_code?(customer)
      customer[:state].present? && customer[:postal_code].present?
    end

    def document_number_missing?
      @payload.input[:document_number].to_s.empty?
    end

    def document_number_too_long?
      @payload.input[:document_number].to_s.length > DOCUMENT_NUMBER_LIMIT
    end
  end
end
