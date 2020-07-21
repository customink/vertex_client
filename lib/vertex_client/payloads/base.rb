require 'active_support'
module VertexClient
  module Payload
    class Base

      # https://www.agiis.org/Links/ErrorCodes.htm
      ADDRESS_VALIDATION_CODES = %w[
        E101 E212 E213 E214 E216 E302 E412 E413 E420 E421 E422 E423 E425 E427 E428 E429 E430 E431
        E432 E433 E434 E435 E436 E437 E439 E450 E451 E452 E453 E501 E502 E503 E504 E505 E600 E601
      ].freeze

      attr_reader :params

      def initialize(params)
        @params = params.with_indifferent_access
        validate!
      end

      def transform
        {
          request_key => body
        }
      end

      def map_to_validation_exception!(exception)
        return exception unless ADDRESS_VALIDATION_CODES.include?(fault_code(exception.message))

        VertexClient::ValidationError.new("Invalid address: #{exception.message}")
      end

      private

      def fault_code(message)
        message.match(/fault code=(?<code>\w+),/)&.[](:code)
      end

      def request_key
        :"#{self.class.name.demodulize.underscore}_request"
      end

      def transform_customer(customer)
        remove_nils({
          :@isTaxExempt =>  customer[:is_tax_exempt],
          destination: remove_nils({
            street_address_1: customer[:address_1],
            street_address_2: customer[:address_2],
            city:             customer[:city],
            main_division:    customer[:state],
            postal_code:      customer[:postal_code],
            country:          customer[:country]
          })
        })
      end

      def remove_nils(hash)
        hash.select {|_key, value| value.present? }
      end
    end
  end
end
