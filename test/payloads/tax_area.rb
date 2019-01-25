require 'test_helper'

describe VertexClient::Payload::TaxArea do
  include TestInput
  let(:payload) do
    VertexClient::Payload::TaxArea.new(tax_area_params)
  end

  it 'has a body' do
    expected_body = {
      tax_area_lookup: {
        postal_address: {
          street_address_1: '2910 District Ave #300',
          city: 'Fairfax',
          main_division: 'VA',
          postal_code: '22031'
        }
      }
    }
    assert_equal expected_body, payload.body
  end

  it 'raises if there are no values in the params' do
    assert_raises VertexClient::ValidationError do
      VertexClient::Payload::TaxArea.new({}).body
    end
  end
end
