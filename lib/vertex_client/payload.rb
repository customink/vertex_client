module VertexClient
  class Payload

    attr_reader :output

    def initialize(input)
      @input = input.dup
      @output = {}
    end

    def transform
      line_items = @input.delete(:line_items)
      defaults = @input
      @output = init_hash
      @output[:discount] = transform_discount(@input[:discount])
      line_items.each_with_index do |line_item, number|
        @output[:line_item] << transform_line_item(line_item, number, defaults)
      end
      self
    end

    private

    def init_hash
      { :'@transactionType' => 'SALE', line_item: [] }
    end

    def transform_line_item(line_item, number, defaults)
      remove_nils({
        :'@lineItemNumber' => number,
        date:           line_item[:date] || defaults[:date],
        customer:       transform_customer(line_item[:customer] || defaults[:customer]),
        seller:         line_item[:seller] || defaults[:seller],
        product:        line_item[:product_code],
        quantity:       line_item[:quantity],
        extended_price: line_item[:price],
        discount:       transform_discount(line_item[:discount])
      })
    end

    def transform_customer(customer)
      {
        destination: remove_nils({
          street_address_1: customer[:address_1],
          street_address_2: customer[:address_2],
          city:             customer[:city],
          main_division:    customer[:state],
          postal_code:      customer[:postal_code]
        })
      }
    end

    def transform_discount(discount)
      remove_nils(discount_amount: discount) if discount
    end

    def remove_nils(hash)
      hash.delete_if {|_key, value| value.nil? }
    end
  end
end
