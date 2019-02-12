require 'test_helper'

describe VertexClient::Response::TaxAreaFallback do
  it 'has a nil tax_area_id' do
    assert_nil VertexClient::Response::TaxAreaFallback.new.tax_area_id
  end
end
