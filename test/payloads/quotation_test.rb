require 'test_helper'

describe VertexClient::Payload::Quotation do
  include TestInput
  let(:payload) do
    VertexClient::Payload::Quotation.new(working_quote_params)
  end

  it 'has a body' do
    assert_equal expected_payload_output, payload.body
  end

  it 'supports sending is_tax_exempt to customer' do
    working_quote_params[:customer][:is_tax_exempt] = true
    assert payload.body[:line_item][0][:customer][:@isTaxExempt]
  end

  it 'supports setting tax_area_id on customer, and excludes any other address details if it is provided' do
    working_quote_params[:customer][:tax_area_id] = '1337'
    assert_equal({:@taxAreaId => '1337' }, payload.body[:line_item][0][:customer][:destination])
  end

  describe 'validate!' do
    describe 'for US customer' do
      it 'is happy if state and postal_code are present on customer' do
        VertexClient::Payload::Quotation.new(working_quote_params).validate!
      end

      it 'raises if the customer is missing state' do
        working_quote_params[:customer].delete(:state)
        assert_raises VertexClient::ValidationError do
          VertexClient::Payload::Quotation.new(working_quote_params).body
        end
      end

      it 'raises if the customer is missing postal_code' do
        working_quote_params[:customer].delete(:postal_code)
        assert_raises VertexClient::ValidationError do
          VertexClient::Payload::Quotation.new(working_quote_params).body
        end
      end
    end

    describe 'for EU customer' do
      before(:each) do
        working_eu_quote_params[:customer].delete(:state)
      end

      it 'is happy if country and postal_code are present on customer' do
        VertexClient::Payload::Quotation.new(working_eu_quote_params).validate!
      end

      it 'raises if the customer is missing country' do
        working_eu_quote_params[:customer].delete(:country)
        assert_raises VertexClient::ValidationError do
          VertexClient::Payload::Quotation.new(working_eu_quote_params).body
        end
      end

      it 'raises if the customer is missing postal_code' do
        working_eu_quote_params[:customer].delete(:postal_code)
        assert_raises VertexClient::ValidationError do
          VertexClient::Payload::Quotation.new(working_eu_quote_params).body
        end
      end
    end
  end
end
