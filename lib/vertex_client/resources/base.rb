require 'active_support'
module VertexClient
  module Resource
    class Base
      class NotImplementedError < StandardError; end

      def initialize(params)
        @payload = payload_type.new(params)
      end

      def result
        @result ||= (formatted_response(response) || fallback_response)
      end

      def result!
        formatted_response(response!)
      end

      def config_key
        demodulized_class_name.underscore.to_sym
      end

      def fallback_response
        raise NotImplementedError
      end

      private

      def response
        connection.request(@payload.transform)
      end

      def response!
        connection.request!(@payload.transform)
      end

      def connection
        @connection ||= Connection.new(self.class::ENDPOINT, config_key)
      end

      def formatted_response(raw_response)
        response_type.new(raw_response) if raw_response
      end

      def payload_type
        Kernel.const_get("VertexClient::Payload::#{demodulized_class_name}")
      end

      def response_type
        Kernel.const_get("VertexClient::Response::#{demodulized_class_name}")
      end

      def demodulized_class_name
        self.class.name.demodulize
      end
    end
  end
end
