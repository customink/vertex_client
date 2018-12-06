require "test_helper"

describe VertexClient::FallbackResponse do
  include TestInput

  before do
    params = working_quote_params
    params[:line_items].last[:price] = "100.00"
    payload = VertexClient::QuotationPayload.new(working_quote_params)
    @response = VertexClient::FallbackResponse.new(payload)
  end

  it 'calculates tax on the fallback response' do
    assert_equal BigDecimal.new('141.5'), @response.total
    assert_equal BigDecimal.new('135.5'), @response.subtotal
    assert_equal BigDecimal.new('6.00'), @response.total_tax
  end

  it 'calculates tax on the fallback response line items' do
    @response.line_items.each { |li| refute_nil li.total_tax }
    assert_equal BigDecimal.new('6.00'), @response.line_items.last.total_tax
  end
end
