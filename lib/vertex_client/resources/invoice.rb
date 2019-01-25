module VertexClient
  module Resource
    class Invoice < Base
      ENDPOINT = 'CalculateTax70'.freeze
      ERROR_MESSAGE = 'The Vertex API returned an error or is unavailable'.freeze

      def fallback_response
        raise ServerError, ERROR_MESSAGE
      end
    end
  end
end
