module VertexClient
  class Connection

    VERTEX_NAMESPACE = "urn:vertexinc:o-series:tps:7:0".freeze

    def request(type, input)
      response = call_with_circuit_if_available do
        client.call(
          :vertex_envelope,
          message: payload(type, input)
        )
      end
      Response.new(response.body) if response
    end

    def payload(request_type, input)
      payload_hash = shell_with_auth
      transform_payload = Payload.new(input, request_type).transform
      payload_hash["#{request_type}_request".to_sym] = transform_payload.output
      payload_hash
    end

    private

    def call_with_circuit_if_available
      VertexClient.circuit ? VertexClient.circuit.run{ yield } : yield
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
