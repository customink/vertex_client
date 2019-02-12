require 'test_helper'

describe VertexClient::Payload::QuotationFallback do
  include TestInput

  let(:payload) do
    VertexClient::Payload::QuotationFallback.new(quotation_fallback_params)
  end

  it 'does not include tax_area_id in the body' do
    expected_destination = {
      street_address_1: '11 Wall Street',
      city: 'New York',
      main_division: 'NY',
      postal_code: '10005',
      country: 'US'
    }
    assert_equal expected_destination, payload.body[:line_item][0][:customer][:destination]
  end
end
