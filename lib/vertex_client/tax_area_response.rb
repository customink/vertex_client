module VertexClient
  class TaxAreaResponse

    attr_reader :body, :tax_area_id

    def initialize(response_data)
      @body = response_data.with_indifferent_access
      @tax_area_id = response_data[:tax_area_result][:@tax_area_id]
    end
  end
end
