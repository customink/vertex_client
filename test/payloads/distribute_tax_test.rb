require 'test_helper'

describe VertexClient::Payload::DistributeTax do
  include TestInput

  let(:payload) do
    VertexClient::Payload::DistributeTax.new(distribute_tax_params)
  end

  it 'includes input_total_tax for line_items' do
    assert_equal '5.00', payload.body[:line_item].first[:input_total_tax]
  end

  describe 'validate!' do
    it 'raises if the document_number is not included' do
      assert_raises VertexClient::ValidationError do
        distribute_tax_params.delete(:document_number)
        VertexClient::Payload::DistributeTax.new(working_quote_params).validate!
      end
    end

    it 'raises if the customer state is not included' do
      assert_raises VertexClient::ValidationError do
        distribute_tax_params[:customer].delete(:state)
        VertexClient::Payload::DistributeTax.new(distribute_tax_params).validate!
      end
    end

    it 'raises if the customer postal_code is not included' do
      assert_raises VertexClient::ValidationError do
        distribute_tax_params[:customer].delete(:postal_code)
        VertexClient::Payload::DistributeTax.new(distribute_tax_params).validate!
      end
    end

    it 'raises if total_tax is not specified on all line items' do
      assert_raises VertexClient::ValidationError do
        distribute_tax_params[:line_items][0].delete(:total_tax)
        VertexClient::Payload::DistributeTax.new(distribute_tax_params).validate!
      end
    end
  end
end
