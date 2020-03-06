# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/tax_area_fallback'

describe VertexClient::Responses::TaxAreaFallback do
  it 'has a nil tax_area_id' do
    assert_nil VertexClient::Responses::TaxAreaFallback.new.tax_area_id
  end
end
