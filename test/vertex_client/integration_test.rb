# frozen_string_literal: true

require 'test_helper'

describe 'VertexClient Integration Test', :vcr do
  include TestInput

  before { VertexClient.reconfigure! }
  after { VertexClient.reconfigure! }

  describe 'Normal Quotation' do
    subject { VertexClient.quotation(working_quote_params) }

    let(:line_item) { subject.line_items.first }

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::Quotation, subject
    end

    it 'returns the correct total tax for the quotation' do
      assert_equal 1.52, subject.total_tax
    end

    it 'returns the correct product code in the line item' do
      assert_equal '4600', line_item.product.product_code
    end

    it 'returns the correct product class in the line item' do
      assert_equal '53103000', line_item.product.product_class
    end
  end

  describe 'Single LineItem Quotation' do
    subject { VertexClient.quotation(single_line_item_quotation_params) }

    let(:line_item) { subject.line_items.first }

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::Quotation, subject
    end

    it 'returns the correct total_tax for the line item' do
      assert_equal 1.52, line_item.total_tax
    end
  end

  describe 'Invoice' do
    subject { VertexClient.invoice(working_quote_params) }

    it 'returns the correct response type' do
      assert_kind_of(VertexClient::Responses::Invoice, subject)
    end

    it 'returns the correct total tax' do
      assert_equal 1.52, subject.total_tax
    end
  end

  describe 'Distribute Tax' do
    subject { VertexClient.distribute_tax(distribute_tax_params) }

    it 'returns the correct response type' do
      assert_kind_of(VertexClient::Responses::DistributeTax, subject)
    end

    it 'returns the correct tax total' do
      assert_equal 5.0.to_d, subject.total_tax
    end
  end

  describe 'Tax Area with multiple responses' do
    subject { VertexClient.tax_area(tax_area_payload) }

    let(:tax_area_payload) do
      {
        address_1: '126487 N Bridge Rd',
        city: 'Aberdeen',
        state: 'SD',
        postal_code: '57401'
      }
    end

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::TaxArea, subject
    end

    it 'returns the correct tax area id' do
      assert_equal '420130000', subject.tax_area_id
    end
  end

  describe 'Quotation with Tax Exempt' do
    subject { VertexClient.quotation(tax_exempt_params) }

    it 'returns the correct response type' do
      assert_kind_of(VertexClient::Responses::Quotation, subject)
    end

    it 'returns the correct total tax' do
      assert_equal 0.0, subject.total_tax
    end

    it 'returns the correct total' do
      assert_equal 50.0, subject.total
    end
  end

  describe 'Invoice with Tax Exempt' do
    subject { VertexClient.invoice(tax_exempt_params) }

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::Invoice, subject
    end

    it 'returns the correct amount of total tax' do
      assert_equal 0.0, subject.total_tax
    end

    it 'returns the correct total' do
      assert_equal 50.0, subject.total
    end
  end

  describe 'Distribute Tax with Tax Exempt' do
    subject { VertexClient.distribute_tax(tax_exempt_params) }

    before { tax_exempt_params[:line_items][0][:total_tax] = '0.00' }

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::DistributeTax, subject
    end

    it 'returns the correct total tax' do
      assert_equal 0.0, subject.total_tax
    end

    it 'returns the correct total' do
      assert_equal 50.0, subject.total
    end
  end

  describe 'Quotation with Location Code' do
    subject { VertexClient.quotation(quotation_with_location_code_params) }

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::Quotation, subject
    end

    it 'returns the correct tax amount' do
      assert_equal 0.0, subject.total_tax
    end

    it 'returns the correct amount for the total' do
      assert_equal 50.0, subject.total
    end
  end

  describe 'Invoice with Location Code' do
    subject { VertexClient.invoice(quotation_with_location_code_params) }

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::Invoice, subject
    end

    it 'returns the correct tax amount' do
      assert_equal 0.0, subject.total_tax
    end

    it 'returns the correct amount for the total' do
      assert_equal 50.0, subject.total
    end
  end

  describe 'Distribute Tax with Location Code' do
    subject { VertexClient.distribute_tax(quotation_with_location_code_params) }

    before { quotation_with_location_code_params[:line_items][0][:total_tax] = '0.00' }

    it 'returns the correct response type' do
      assert_kind_of VertexClient::Responses::DistributeTax, subject
    end

    it 'returns the correct tax amount' do
      assert_equal 0.0, subject.total_tax
    end

    it 'returns the correct amount for the total' do
      assert_equal 50.0, subject.total
    end
  end

  describe 'Fallback Responses' do
    describe 'Quotation' do
      subject { VertexClient.quotation(working_quote_params) }

      before { VertexClient::Resources::Quotation.any_instance.stubs(:response).returns(nil) }

      it 'returns a fallback response' do
        assert_kind_of(VertexClient::Responses::QuotationFallback, subject)
      end
    end
  end
end
