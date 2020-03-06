# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/tax_area'

describe VertexClient::Responses::TaxArea do
  subject { VertexClient::Responses::TaxArea.new(vertex_tax_area_response) }

  let(:vertex_tax_area_response) do
    OpenStruct.new(
      body: {
        vertex_envelope: {
          tax_area_response: {
            tax_area_result: {
              '@tax_area_id': '1337'
            }
          }
        }
      }
    )
  end

  it 'has a tax_area_id' do
    assert_equal '1337', subject.tax_area_id
  end
end
