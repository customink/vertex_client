# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/payloads/quotation'

describe VertexClient::Payloads::Quotation do
  include TestInput

  subject { VertexClient::Payloads::Quotation.new(working_quote_params) }

  it 'has a body' do
    assert_equal expected_payload_output, subject.body
  end

  it 'supports sending is_tax_exempt to customer' do
    working_quote_params[:customer][:is_tax_exempt] = true

    assert subject.body[:line_item][0][:customer][:@isTaxExempt]
  end

  it 'supports setting tax_area_id on customer, and excludes any other address details if it is provided' do
    working_quote_params[:customer][:tax_area_id] = '1337'

    assert_equal({ :@taxAreaId => '1337' }, subject.body[:line_item][0][:customer][:destination])
  end

  describe 'validate!' do
    it 'is happy if state and postal_code are present on customer' do
      VertexClient::Payloads::Quotation.new(working_quote_params).validate!
    end

    it 'raises if the customer is missing state' do
      working_quote_params[:customer].delete(:state)

      assert_raises VertexClient::ValidationError do
        VertexClient::Payloads::Quotation.new(working_quote_params).body
      end
    end

    it 'raises if the customer is missing postal_code' do
      working_quote_params[:customer].delete(:postal_code)

      assert_raises VertexClient::ValidationError do
        VertexClient::Payloads::Quotation.new(working_quote_params).body
      end
    end
  end
end
