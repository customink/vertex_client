# frozen_string_literal: true

require 'test_helper'

describe 'Payload Validation' do
  include TestInput

  let(:payload) { working_quote_params }

  describe 'Quotation' do
    subject { VertexClient::Payloads::Quotation.new(payload) }

    before do
      payload[:customer].delete(:postal_code)
      payload[:customer].delete(:state)
    end

    it 'raises a ValidationError' do
      assert_raises(VertexClient::ValidationError) { subject }
    end
  end

  describe 'Invoice' do
    subject { VertexClient::Payloads::Invoice.new(payload) }

    it 'raises a validation error if the document number is missing' do
      payload.delete(:document_number)

      assert_raises(VertexClient::ValidationError) { subject }
    end

    it 'raises a validation error if the document number is too long' do
      payload[:document_number] = 'a-document-number-that-is-too-many-characters'

      assert_raises(VertexClient::ValidationError) { subject }
    end
  end
end
