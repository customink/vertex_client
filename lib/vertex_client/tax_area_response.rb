module VertexClient
  class TaxAreaResponse

    attr_reader :body, :tax_area_id

    def initialize(response, response_key)
      @body = response.body[:vertex_envelope][response_key].with_indifferent_access
      @tax_area_id = response.body[:vertex_envelope][response_key][:tax_area_result][:@tax_area_id]
    end
  end
end
