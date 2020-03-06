# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/payloads/quotation_fallback'

describe VertexClient::Payloads::QuotationFallback do
  include TestInput

  subject { VertexClient::Payloads::QuotationFallback.new(quotation_fallback_params) }

  it 'does not include tax_area_id in the body' do
    expected_destination = {
      street_address_1: '11 Wall Street',
      city: 'New York',
      main_division: 'NY',
      postal_code: '10005',
      country: 'US'
    }
    assert_equal expected_destination, subject.body[:line_item][0][:customer][:destination]
  end
end
