require 'active_support'
module VertexClient
  module Payload
    class Base

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

      private

      def request_key
        :"#{self.class.name.demodulize.underscore}_request"
      end

      def transform_customer(customer)
        remove_nils({
          :@isTaxExempt =>  customer[:is_tax_exempt],
          destination: transform_address(customer)
        })
      end

      def transform_address(address)
        return unless address
        remove_nils({
          street_address_1: address[:address_1],
          street_address_2: address[:address_2],
          city:             address[:city],
          main_division:    address[:state],
          postal_code:      address[:postal_code],
          country:          address[:country]
        })
      end

      def remove_nils(hash)
        hash.select {|_key, value| value.present? }
      end
    end
  end
end
