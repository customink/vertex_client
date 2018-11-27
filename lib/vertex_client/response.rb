module VertexClient
  class Response

    attr_reader :body, :total_tax, :total, :subtotal

    def initialize(response, response_key)
      @body      = response[:vertex_envelope][response_key].with_indifferent_access
      @total_tax = BigDecimal.new(@body[:total_tax])
      @total     = BigDecimal.new(@body[:total])
      @subtotal  = BigDecimal.new(@body[:sub_total])
    end
  end
end
