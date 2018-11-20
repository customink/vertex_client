module VertexClient
  class Response

    attr_reader :body, :total_tax, :total, :subtotal

    def initialize(response)
      @body      = response[:vertex_envelope][:quotation_response]
      @total_tax = @body[:total_tax]
      @total     = @body[:total]
      @subtotal  = @body[:sub_total]
    end
  end
end
