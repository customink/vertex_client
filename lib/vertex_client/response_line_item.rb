module VertexClient
  class ResponseLineItem

    attr_reader :total_tax, :product_code, :raw, :quantity, :price

    def initialize(params={})
      @raw          = params[:raw]
      @total_tax    = BigDecimal.new(params[:total_tax] || '0.0')
      @product_code = params[:product_code]
      @quantity     = params[:quantity]
      @price        = params[:price]
    end

    def self.init_from_hash(line_item)
      self.new(
        raw:          line_item,
        total_tax:    line_item[:total_tax],
        product_code: line_item[:product],
        quantity:     line_item[:quantity],
        price:        line_item[:extended_price]
      )
    end
  end
end
