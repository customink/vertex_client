require "test_helper"

describe VertexClient::PayloadValidator do
  include TestInput

  it 'raises a error for missing location' do
    payload = working_quote_params
    payload[:customer].delete(:postal_code)
    payload[:customer].delete(:state)
    payload = VertexClient::QuotationPayload.new(payload)
    assert_raises VertexClient::PayloadValidationError do
      VertexClient::PayloadValidator.new(payload, [:location]).validate!
    end
  end

  it 'raises if the document_number is not included' do
    payload = working_quote_params
    payload.delete(:document_number)
    payload = VertexClient::QuotationPayload.new(payload)
    assert_raises VertexClient::PayloadValidationError do
      VertexClient::PayloadValidator.new(payload, [:document_number]).validate!
    end
  end

  it 'raises if the document_number is too long' do
    payload = working_quote_params
    payload[:document_number] = 'a-document-number-that-is-too-many-characters'
    payload = VertexClient::QuotationPayload.new(payload)
    assert_raises VertexClient::PayloadValidationError do
      VertexClient::PayloadValidator.new(payload, [:document_number]).validate!
    end
  end
end
