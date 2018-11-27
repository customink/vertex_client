module VertexClient
  class Connection

    VERTEX_NAMESPACE = "urn:vertexinc:o-series:tps:7:0".freeze

    def request(payload_object)
      response = call_with_circuit_if_available do
        client.call(
          :vertex_envelope,
          message: payload(payload_object)
        )
      end
      Response.new(response.body, payload_object.response_key) if response
    end

    def payload(payload_object)
      payload_hash = shell_with_auth
      transform_payload = payload_object.transform
      payload_hash[payload_object.request_key] = transform_payload.output
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
