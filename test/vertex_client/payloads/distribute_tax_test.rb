# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/payloads/distribute_tax'

describe VertexClient::Payloads::DistributeTax do
  include TestInput

  subject { VertexClient::Payloads::DistributeTax.new(distribute_tax_params) }

  describe '#initialize' do
    it 'properly assigns the parameters' do
      assert_equal(distribute_tax_params.with_indifferent_access, subject.params)
    end
  end

  describe '#body' do
    it 'returns the transaction type in the body' do
      assert subject.body.key?(:"@transactionType")
    end

    it 'returns the correct transaction type' do
      assert_equal VertexClient::Payloads::Quotation::SALE_TRANSACTION_TYPE, subject.body[:"@transactionType"]
    end

    it 'contains the line items key' do
      assert subject.body.key?(:line_item)
    end

    it 'contains the document number key' do
      assert subject.body.key?(:"@documentNumber")
    end

    it 'contains the document date key' do
      assert subject.body.key?(:"@documentDate")
    end

    it 'includes input_total_tax for line_items' do
      assert_equal '5.00', subject.body[:line_item].first[:input_total_tax]
    end
  end

  describe '#validate!' do
    let(:invalid_params) do
      params = distribute_tax_params.dup
      params[:line_items].first[:total_tax] = nil
      params
    end

    it 'does not raise an error when the payload is correct' do
      subject.validate!
    end

    it 'raises a ValidationError when the tax is missing on line items' do
      subject.instance_variable_set(:"@params", invalid_params)

      assert_raises(VertexClient::ValidationError, 'total_tax must be specified for all line items') do
        subject.validate!
      end
    end

    it 'raises if the document_number is not included' do
      assert_raises VertexClient::ValidationError do
        distribute_tax_params.delete(:document_number)
        VertexClient::Payloads::DistributeTax.new(working_quote_params).validate!
      end
    end

    it 'raises if the customer state is not included' do
      assert_raises VertexClient::ValidationError do
        distribute_tax_params[:customer].delete(:state)
        VertexClient::Payloads::DistributeTax.new(distribute_tax_params).validate!
      end
    end

    it 'raises if the customer postal_code is not included' do
      assert_raises VertexClient::ValidationError do
        distribute_tax_params[:customer].delete(:postal_code)
        VertexClient::Payloads::DistributeTax.new(distribute_tax_params).validate!
      end
    end

    it 'raises if total_tax is not specified on all line items' do
      assert_raises VertexClient::ValidationError do
        distribute_tax_params[:line_items][0].delete(:total_tax)
        VertexClient::Payloads::DistributeTax.new(distribute_tax_params).validate!
      end
    end
  end
end
