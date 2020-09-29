require 'test_helper'
require_relative './tax_only_adjustment_examples'

describe VertexClient::Payload::Quotation do
  include TestInput
  extend VertexClient::Payload::TaxOnlyAdjustmentExamples

  let(:payload) do
    VertexClient::Payload::Quotation.new(working_quote_params)
  end

  it 'has a body' do
    assert_equal expected_payload_output, payload.body
  end

  it_supports_tax_only_adjustments(:working_quote_params)

  it 'supports sending is_tax_exempt to customer' do
    working_quote_params[:customer][:is_tax_exempt] = true
    assert payload.body[:line_item][0][:customer][:@isTaxExempt]
  end

  it 'supports setting tax_area_id on customer, and excludes any other address details if it is provided' do
    working_quote_params[:customer][:tax_area_id] = '1337'
    assert_equal({:@taxAreaId => '1337' }, payload.body[:line_item][0][:customer][:destination])
  end

  it 'supports sending delivery_term to body' do
    working_quote_params[:delivery_term] = 'DAP'
    assert_equal('DAP', payload.body[:@deliveryTerm])
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

    describe 'for seller override' do
      describe 'without physical_origin' do
        it 'does not raise' do
          VertexClient::Payload::Quotation.new(working_eu_quote_params).validate!
        end
      end

      describe 'with physical_origin' do
        describe 'from US' do
          before(:each) do
            working_eu_quote_params[:line_items][1][:seller][:physical_origin] = {
              address_1: '2910 District Ave #300',
              city: 'Fairfax',
              postal_code: '22031',
              state: 'VA'
            }
          end

          it 'does not raise if state and postal_code are present' do
            VertexClient::Payload::Quotation.new(working_eu_quote_params).validate!
          end
          
          it 'raises if physical_origin is missing state' do
            working_eu_quote_params[:line_items][1][:seller][:physical_origin].delete(:state)
            assert_raises VertexClient::ValidationError do
              VertexClient::Payload::Quotation.new(working_eu_quote_params).body
            end
          end

          it 'raises if physical_origin is missing postal_code' do
            working_eu_quote_params[:line_items][1][:seller][:physical_origin].delete(:postal_code)
            assert_raises VertexClient::ValidationError do
              VertexClient::Payload::Quotation.new(working_eu_quote_params).body
            end
          end
        end

        describe 'from EU' do
          before(:each) do
            working_eu_quote_params[:line_items][1][:seller][:physical_origin] = {
              address_1: 'Prujezdna 320/62',
              city: 'Praha',
              postal_code: '100 00',
              country: 'CZ'
            }
          end

          it 'does not raise if country and postal_code are present' do
            VertexClient::Payload::Quotation.new(working_eu_quote_params).validate!
          end

          it 'raises if physical_origin is missing country' do
            working_eu_quote_params[:line_items][1][:seller][:physical_origin].delete(:country)
            assert_raises VertexClient::ValidationError do
              VertexClient::Payload::Quotation.new(working_eu_quote_params).body
            end
          end

          it 'raises if physical_origin is missing postal_code' do
            working_eu_quote_params[:line_items][1][:seller][:physical_origin].delete(:postal_code)
            assert_raises VertexClient::ValidationError do
              VertexClient::Payload::Quotation.new(working_eu_quote_params).body
            end
          end
        end
      end
    end
  end
end
