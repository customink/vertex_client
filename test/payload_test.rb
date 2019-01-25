require "test_helper"

describe VertexClient::Payload do
  include TestInput

  it 'supports sending is_tax_exempt to customer' do
    working_quote_params[:customer][:is_tax_exempt] = true
    output = VertexClient::Payload::Invoice.new(working_quote_params).body
    assert output[:line_item][0][:customer][:@isTaxExempt]
  end
end
