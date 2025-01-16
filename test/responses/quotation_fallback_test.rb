require 'test_helper'

describe VertexClient::Response::QuotationFallback do
  include TestInput

  let(:payload) { VertexClient::Payload::QuotationFallback.new(working_quote_params) }
  let(:response) { VertexClient::Response::QuotationFallback.new(payload) }

  before do
    working_quote_params[:line_items].last[:price] = '100.0'
  end

  # it 'initializes @body with payload.body' do
  #   assert_equal payload.body, response.instance_variable_get(:@body)
  # end

  # describe 'subtotal' do
  #   it 'is the sum of price from line_items' do
  #     assert_equal 135.5, response.subtotal.to_f
  #   end

  #   it 'handles empty quotes' do
  #     working_quote_params[:line_items] = []
  #     assert_equal 0.0, response.subtotal.to_f
  #   end
  # end

  describe 'total_tax' do
    describe 'for country-less customer' do
      let(:countryless_params) do
        working_quote_params.tap do |wqp|
          wqp[:customer].delete(:country)
          wqp[:line_items][1][:customer].delete(:country)
        end
      end
      let(:payload) { VertexClient::Payload::QuotationFallback.new(countryless_params) }

      it 'assumes they are from the US' do
        assert_equal 8.66, response.total_tax.to_f
      end
    end

    # describe 'for US customer' do
    #   it 'is the sum of total_tax from line_items' do
    #     assert_equal 8.66, response.total_tax.to_f
    #   end

    #   it 'handles empty quotes' do
    #     working_quote_params[:line_items] = []
    #     assert_equal 0.0, response.total_tax.to_f
    #   end

    #   it 'handle unrecognized states' do
    #     working_quote_params[:customer][:state] = 'XY'
    #     working_quote_params[:line_items][1][:customer][:state] = 'XY'
    #     assert_equal 0.0, response.total_tax.to_f
    #   end
    # end

    # describe 'for EU customer' do
    #   let(:payload) { VertexClient::Payload::QuotationFallback.new(working_eu_quote_params) }

    #   it 'is the sum of total_tax from line_items' do
    #     assert_equal 0.0, response.total_tax.to_f
    #   end
    # end

    # describe 'for other countries' do
    #   let(:intl_params) do
    #     working_quote_params.tap do |wqp|
    #       wqp[:customer][:country] = 'TZ'
    #       wqp[:customer].delete(:state)
    #       wqp[:line_items][1][:customer][:country] = 'TZ'
    #       wqp[:line_items][1][:customer].delete(:state)
    #     end
    #   end
    #   let(:payload) { VertexClient::Payload::QuotationFallback.new(intl_params) }

    #   it 'is the sum of total_tax from line_items' do
    #     assert_equal 0.0, response.total_tax.to_f
    #   end
    # end
  end

  # describe 'total' do
  #   it 'is the sum of subtotal and total_tax' do
  #     assert_equal 144.16, response.total.to_f
  #   end
  # end

  # describe 'line_items' do
  #   it 'is a collection of Response::LineItem' do
  #     assert_equal 2,          response.line_items.size
  #     assert_equal '4600',     response.line_items.first.product.product_code
  #     assert_equal '53103000', response.line_items.first.product.product_class
  #     assert_equal 7,          response.line_items.first.quantity
  #     assert_equal 35.5,       response.line_items.first.price.to_f
  #   end
  # end
end
