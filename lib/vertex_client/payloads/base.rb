# frozen_string_literal: true

require 'active_support'
module VertexClient
  module Payloads
    class Base
      attr_reader :params

      def initialize(params)
        @params = params.with_indifferent_access
        validate!
      end

      def transform
        { request_key => body }
      end

      def body
        raise NotImplementedError, 'This needs to be implemented in the inheriting classes'
      end

      def validate!
        raise NotImplementedError, 'This needs to be implemented in the inheriting classes'
      end

      private

      def request_key
        :"#{self.class.name.demodulize.underscore}_request"
      end

      def transform_customer(customer)
        remove_nils({
                      :@isTaxExempt => customer[:is_tax_exempt],
                      destination: remove_nils({
                                                 street_address_1: customer[:address_1],
                                                 street_address_2: customer[:address_2],
                                                 city: customer[:city],
                                                 main_division: customer[:state],
                                                 postal_code: customer[:postal_code],
                                                 country: customer[:country]
                                               })
                    })
      end

      def remove_nils(hash)
        hash.select { |_key, value| value.present? }
      end
    end
  end
end
