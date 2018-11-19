module VertexClient
  class Response

    attr_reader :body, :total_tax, :price_with_tax

    def initialize(response)
      @body = response[:vertex_envelope][:quotation_response]
      @total_tax = @body[:total_tax]
      @price_with_tax = @body[:total]
    end
  end
end
