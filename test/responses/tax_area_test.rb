require "test_helper"

describe VertexClient::Response::TaxArea do
  let(:vertex_tax_area_response) do
    OpenStruct.new(body: {
      vertex_envelope: {
        tax_area_response: {
          tax_area_result: {
            :'@tax_area_id' => '1337'
          }
        }
      }
    })
  end

  let(:response) { VertexClient::Response::TaxArea.new(vertex_tax_area_response) }

  it 'has a tax_area_id' do
    assert_equal '1337', response.tax_area_id
  end
end
