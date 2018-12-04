module VertexClient
  class Response

    attr_reader :body, :total_tax, :total, :subtotal, :line_items

    def initialize(response, response_key)
      @body       = response[:vertex_envelope][response_key].with_indifferent_access
      @total_tax  = BigDecimal.new(@body[:total_tax])
      @total      = BigDecimal.new(@body[:total])
      @subtotal   = BigDecimal.new(@body[:sub_total])
      @line_items = create_line_items
    end

    private

    def create_line_items
      [].tap do |items|
        [@body[:line_item]].flatten.each do |line_item|
          items << ResponseLineItem.init_from_hash(line_item)
        end
      end
    end
  end
end
