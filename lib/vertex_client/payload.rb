module VertexClient
  class Payload

    SALE = 'SALE'.freeze

    attr_reader :output

    def initialize(input, request_type)
      @input = input.dup
      @request_type = request_type
      @output = {}
    end

    def transform
      validate!
      line_items = @input.delete(:line_items)
      @output = init_hash
      defaults = @input
      line_items.each_with_index do |line_item, number|
        @output[:line_item] << transform_line_item(line_item, number, defaults)
      end
      self
    end

    private

    def validate!
      raise VertexClient::Error.new('document_number is required for invoice') if document_number_missing?
      raise VertexClient::Error.new('document_number must be less than or equal to 40 characters') if document_number_too_long?
    end

    def invoice?
      @request_type == VertexClient::INVOICE
    end

    def document_number_missing?
      invoice? && @input[:document_number].to_s.empty?
    end

    def document_number_too_long?
      invoice? && @input[:document_number].to_s.length > 40
    end

    def init_hash
      hash = {
        :'@transactionType' => SALE,
        line_item: []
      }
      if invoice?
        hash[:'@documentNumber'] = @input.delete(:document_number)
        hash[:'@documentDate']   = @input[:date]
      end
      hash
    end

    def transform_line_item(line_item, number, defaults)
      remove_nils({
        :'@lineItemNumber' => number+1,
        :'@taxDate' =>  line_item[:date] || defaults[:date],
        customer:       transform_customer(line_item[:customer] || defaults[:customer]),
        seller:         line_item[:seller] || defaults[:seller],
        product:        line_item[:product_code],
        quantity:       line_item[:quantity],
        extended_price: line_item[:price],
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

    def remove_nils(hash)
      hash.delete_if {|_key, value| value.nil? }
    end
  end
end
