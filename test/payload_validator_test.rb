require 'test_helper'

describe 'payload validation' do
  include TestInput

  it 'raises a error for missing location' do
    payload = working_quote_params
    payload[:customer].delete(:postal_code)
    payload[:customer].delete(:state)
    assert_raises VertexClient::ValidationError do
      VertexClient::Payload::Quotation.new(payload)
    end
  end

  it 'raises if the document_number is not included' do
    payload = working_quote_params
    payload.delete(:document_number)
    assert_raises VertexClient::ValidationError do
      VertexClient::Payload::Invoice.new(payload)
    end
  end

  it 'raises if the document_number is too long' do
    payload = working_quote_params
    payload[:document_number] = 'a-document-number-that-is-too-many-characters'
    assert_raises VertexClient::ValidationError do
      VertexClient::Payload::Invoice.new(payload)
    end
  end
end
