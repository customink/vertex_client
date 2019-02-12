require 'test_helper'

describe VertexClient::Payload::Invoice do
  include TestInput
  let(:payload) do
    VertexClient::Payload::Invoice.new(working_quote_params)
  end

  it 'has a body' do
    assert_equal expected_payload_output.merge({
      :'@documentNumber' => 'test123',
      :'@documentDate' => '2018-11-15'
    }), payload.body
  end

  it 'supports sending is_tax_exempt to customer' do
    working_quote_params[:customer][:is_tax_exempt] = true
    assert payload.body[:line_item][0][:customer][:@isTaxExempt]
  end

  describe 'validate!' do
    it 'raises if the document_number is not included' do
      assert_raises VertexClient::ValidationError do
        working_quote_params.delete(:document_number)
        VertexClient::Payload::Invoice.new(working_quote_params).validate!
      end
    end

    it 'raises if the customer state is not included' do
      assert_raises VertexClient::ValidationError do
        working_quote_params[:customer].delete(:state)
        VertexClient::Payload::Invoice.new(working_quote_params).validate!
      end
    end

    it 'raises if the customer postal_code is not included' do
      assert_raises VertexClient::ValidationError do
        working_quote_params[:customer].delete(:postal_code)
        VertexClient::Payload::Invoice.new(working_quote_params).validate!
      end
    end
  end
end
