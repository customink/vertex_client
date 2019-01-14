module VertexClient
  class FallbackResponse
    include VertexClient::Fallbacks

    attr_reader :body, :total_tax, :total, :subtotal, :line_items

    # Temporary hack for tax_area_lookup
    attr_reader :tax_area_id

    def initialize(payload)
      @payload = payload.transform
      @body = @payload.output
      @total_tax, @subtotal = BigDecimal.new('0.0'), BigDecimal.new('0.0')
      @line_items = []
      generate!
    end

    def generate!
      @body[:line_item].each do |line_item|
        state = line_item[:customer][:destination][:main_division]
        price = BigDecimal.new(line_item[:extended_price].to_s)
        tax = tax_amount(price, state)
        @subtotal  += price
        @total_tax += tax
        line_item[:total_tax] = total_tax.floor(2)
        line_items << ResponseLineItem.init_from_hash(line_item)
      end
      @total_tax = @total_tax.floor(2)
      @total = @subtotal + @total_tax
      @body[:sub_total] = @subtotal
      @body[:total]     = @total
      @body[:total_tax] = @total_tax
    end

    def tax_amount(price, state)
      if RATES.has_key?(state)
        price * BigDecimal.new(RATES[state])
      else
        BigDecimal.new("0.0")
      end
    end

  end
end
