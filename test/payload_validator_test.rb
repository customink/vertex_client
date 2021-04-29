require 'test_helper'

describe 'payload validation' do
  include TestInput

  describe 'for incomplete location' do
    describe 'for US customer' do
      let(:payload) { working_quote_params }

      it 'raises an error when missing postal code' do
        payload[:customer].delete(:postal_code)
        assert_raises VertexClient::ValidationError do
          VertexClient::Payload::Quotation.new(payload)
        end
      end

      it 'raises an error when missing state' do
        payload[:customer].delete(:state)
        assert_raises VertexClient::ValidationError do
          VertexClient::Payload::Quotation.new(payload)
        end
      end
    end

    describe 'for EU customer' do
      let(:payload) { working_eu_quote_params }

      before(:each) do
        payload[:customer].delete(:state)
        payload[:customer].delete(:postal_code)
      end

      it 'raises an error when missing country' do
        payload[:customer].delete(:country)
        assert_raises VertexClient::ValidationError do
          VertexClient::Payload::Quotation.new(payload)
        end
      end
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
