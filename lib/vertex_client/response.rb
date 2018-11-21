module VertexClient
  class Response

    attr_reader :body, :total_tax, :total, :subtotal

    def initialize(response)
      @body      = response[:vertex_envelope][:quotation_response]
      @total_tax = BigDecimal.new(@body[:total_tax])
      @total     = BigDecimal.new(@body[:total])
      @subtotal  = BigDecimal.new(@body[:sub_total])
    end
  end
end
