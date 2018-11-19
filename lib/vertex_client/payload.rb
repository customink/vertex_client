module VertexClient
  class Payload

    attr_reader :output

    def initialize(input)
      @input = input
      @output = {}
    end

    def transform
      default_customer = transform_customer(@input.delete(:customer))
      default_seller   = @input.delete(:seller)
      @output = init_hash
      @input[:line_items].each_with_index do |line_item, number|
        @output[:line_item] << transform_line_item(
          line_item,
          number,
          default_customer: default_customer,
          default_seller:   default_seller
        )
      end
      self
    end

    private

    def init_hash
      { :'@transactionType' => 'SALE', line_item: [] }
    end

    def transform_line_item(line_item, number, options={})
      customer_line = line_item.has_key?(:customer) ? transform_customer(line_item[:customer]) : options[:default_customer]
      seller_line   = line_item.has_key?(:seller) ? line_item[:seller] : options[:default_seller]
      {
        :'@lineItemNumber' => number,
        customer:       customer_line,
        seller:         seller_line,
        product:        line_item[:product_code],
        quantity:       line_item[:quantity],
        extended_price: line_item[:price],
        discount:       line_item[:discount]  # Don't send if nil
      }.delete_if {|_key, value| value.nil? }
    end

    def transform_customer(customer)
      {
        destination: {
          street_address_1: customer[:address_1], # Don't send if nil
          street_address_2: customer[:address_2], # Don't send if nil
          city:             customer[:city],
          main_division:    customer[:state],
          postal_code:      customer[:postal_code]
        }.delete_if {|_key, value| value.nil? }
      }
    end
  end
end
