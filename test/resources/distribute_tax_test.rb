require "test_helper"

describe VertexClient::Resource::DistributeTax do
  include TestInput

  let(:resource){ VertexClient::Resource::DistributeTax.new(working_quote_params) }

  it 'has an ENDPOINT' do
    assert_equal 'CalculateTax70', VertexClient::Resource::DistributeTax::ENDPOINT
  end

  it 'raises when there is no response' do
    resource.stubs(response: nil)
    assert_raises VertexClient::ServerError do
      resource.result
    end
  end
end
