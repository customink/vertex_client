require "test_helper"

describe 'new stuff' do
  include TestInput
  it 'tests' do
    VCR.use_cassette('new') do
      VertexClient.quotation(working_quote_params)
    end
  end
end
