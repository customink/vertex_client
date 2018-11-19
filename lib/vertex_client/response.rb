module VertexClient
  class Response

    attr_reader :body, :total_tax, :total_price

    def initialize(response)
      @body = response[:vertex_envelope][:quotation_response]
      @total_tax = @body[:total_tax]
      @total_price = @body[:price_with_tax]
    end
  end
end
