module VertexClient
  module Response
    class Base
      include Utils::StringUtils

      def initialize(vertex_response)
        @body = vertex_response.body[:vertex_envelope][response_key].with_indifferent_access
      end

      private

      def response_key
        :"#{self.class.name.demodulize.underscore}_response"
      end
    end
  end
end
