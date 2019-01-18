require 'byebug'
module VertexClient
  module Resource
    class Base

      include Utils::StringUtils

      def initialize(params)
        @payload = payload_type.new(params)
      end

      def result
        @result ||= (response ? formatted_response : fallback_response)
      end

      private

      def response
        @response ||= connection.request(@payload.transform)
      end

      def connection
        @connection ||= Connection.new(self.class::ENDPOINT)
      end

      def formatted_response
        response_type.new(response)
      end

      def payload_type
        Kernel.const_get("VertexClient::Payload::#{demodulized_class_name}")
      end

      def response_type
        Kernel.const_get("VertexClient::Response::#{demodulized_class_name}")
      end

      def demodulized_class_name
        demodulize(self.class.name)
      end

    end
  end
end
