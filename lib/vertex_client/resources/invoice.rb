# frozen_string_literal: true

require_relative 'base'
require_relative '../payloads/invoice'
require_relative '../responses/invoice'

module VertexClient
  module Resources
    class Invoice < Base
      ENDPOINT = 'CalculateTax70'
      ERROR_MESSAGE = 'The Vertex API returned an error or is unavailable'

      def fallback_response
        raise ServerError, ERROR_MESSAGE
      end
    end
  end
end
