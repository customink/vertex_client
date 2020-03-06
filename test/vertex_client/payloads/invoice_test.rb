# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/payloads/invoice'

describe VertexClient::Payloads::Invoice do
  include TestInput

  subject { VertexClient::Payloads::Invoice.new(working_quote_params) }

  describe '#body' do
    it 'includes the Document Number in the body' do
      assert subject.body.key?(:"@documentNumber")
    end

    it 'includes the Document Date in the body' do
      assert subject.body.key?(:"@documentDate")
    end

    it 'returns a value for the Document Number' do
      assert_equal 'test123', subject.body[:"@documentNumber"]
    end

    it 'returns a value for the Document Date' do
      assert_equal '2018-11-15', subject.body[:"@documentDate"]
    end

    it 'supports sending is_tax_exempt to customer' do
      working_quote_params[:customer][:is_tax_exempt] = true
      assert subject.body[:line_item][0][:customer][:@isTaxExempt]
    end
  end

  describe 'validate!' do
    it 'raises if the document_number is not included' do
      assert_raises VertexClient::ValidationError do
        working_quote_params.delete(:document_number)
        VertexClient::Payloads::Invoice.new(working_quote_params).validate!
      end
    end

    it 'raises if the customer state is not included' do
      assert_raises VertexClient::ValidationError do
        working_quote_params[:customer].delete(:state)
        VertexClient::Payloads::Invoice.new(working_quote_params).validate!
      end
    end

    it 'raises if the customer postal_code is not included' do
      assert_raises VertexClient::ValidationError do
        working_quote_params[:customer].delete(:postal_code)
        VertexClient::Payloads::Invoice.new(working_quote_params).validate!
      end
    end
  end
end
