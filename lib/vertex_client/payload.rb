module VertexClient
  class Payload

    SALE = 'SALE'.freeze

    attr_reader :output

    def initialize(input)
      @input = input.dup.with_indifferent_access
      @output = {}
    end

    def transform
      line_items = @input.delete(:line_items)
      @output = init_hash
      defaults = @input
      line_items.each_with_index do |line_item, number|
        @output[:line_item] << transform_line_item(line_item, number, defaults)
      end
      self
    end

    def request_key
      "#{payload_name}_request".to_sym
    end

    def response_key
      "#{payload_name}_response".to_sym
    end

    private

    def payload_name
      "#{self.class::NAME}"
    end

    def init_hash
      {
        :'@transactionType' => SALE,
        line_item: []
      }
    end

    def transform_line_item(line_item, number, defaults)
      remove_nils({
        :'@lineItemNumber' => number+1,
        :'@taxDate' =>  line_item[:date] || defaults[:date],
        customer:       transform_customer(line_item[:customer] || defaults[:customer]),
        seller:         transform_seller(line_item[:seller] || defaults[:seller]),
        product:        transform_product(line_item),
        quantity:       line_item[:quantity],
        extended_price: line_item[:price],
      })
    end

    def transform_product(line_item)
      {
        :'@productClass' => line_item[:product_class],
        :content! => line_item[:product_code]
      }
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

    def transform_seller(seller)
      {
        company: seller[:company]
      }
    end

    def remove_nils(hash)
      hash.delete_if {|_key, value| value.nil? }
    end
  end
end
