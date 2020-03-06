# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/payloads/tax_area'

describe VertexClient::Payloads::TaxArea do
  include TestInput

  subject { VertexClient::Payloads::TaxArea.new(tax_area_params) }

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
    assert_equal expected_body, subject.body
  end

  it 'raises if there are no values in the params' do
    assert_raises VertexClient::ValidationError do
      VertexClient::Payloads::TaxArea.new({}).body
    end
  end
end
