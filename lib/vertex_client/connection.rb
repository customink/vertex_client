module VertexClient
  class Connection

    VERTEX_NAMESPACE = "urn:vertexinc:o-series:tps:7:0".freeze
    ERROR_MESSAGE = 'The Vertex API returned an error or is unavailable'.freeze

    def initialize(payload)
      @payload = payload
    end

    def request
      response = call_with_circuit_if_available do
        client.call(
          :vertex_envelope,
          message: transform_payload
        )
      end
      handle_response(response)
    end

    def transform_payload
      payload_hash = shell_with_auth
      transform_payload = @payload.transform
      payload_hash[@payload.request_key] = transform_payload.output
      payload_hash
    end

    private

    # TODO Consider removing this conditional to make this more robust
    def handle_response(response)
      if response
        Response.new(response.body, @payload.response_key)
      elsif @payload.quotation?
        FallbackResponse.new(@payload)
      else
        raise RemoteServerError.new(ERROR_MESSAGE)
      end
    end

    def call_with_circuit_if_available
      if VertexClient.circuit
        VertexClient.circuit.run{ yield }
      else
        begin
          yield
        rescue => _e
          nil
        end
      end
    end

    def shell_with_auth
      {
        login: { trusted_id: @config.trusted_id }
      }
    end

    def config
      @config ||= VertexClient.configuration
    end

    def client
      @client ||= Savon.client do |globals|
        globals.endpoint config.soap_api
        globals.namespace VERTEX_NAMESPACE
        globals.convert_request_keys_to :camelcase
        globals.env_namespace :soapenv
        globals.namespace_identifier :urn
      end
    end
  end
end
