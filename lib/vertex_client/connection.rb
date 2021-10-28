module VertexClient
  class Connection

    VERTEX_NAMESPACE = 'urn:vertexinc:o-series:tps:7:0'.freeze
    ERROR_MESSAGE = 'The Vertex API returned an error or is unavailable'.freeze

    attr_accessor :payload

    def initialize(endpoint, resource_key=nil)
      @endpoint = endpoint
      @resource_key = resource_key
      @payload = {}
    end

    def request(payload)
      @payload = payload
      call_with_circuit_if_available do
        client.call(
          :vertex_envelope,
          message: shell_with_auth.merge(payload)
        )
      end
    end

    def client
      if config.scale_timeout? && resource_config[:scale_timeout] != false
        client_scaled
      else
        client_base
      end
    end

    private

    def client_scaled
      @client_scaled = client_settings
      @client_scaled.globals.open_timeout scaled_timeout
      @client_scaled.globals.read_timeout scaled_timeout
      @client_scaled
    end

    def scaled_timeout
      request_size / timeout_scaling_factor
    end

    def request_size
      payload["line_items"].count
    end

    def client_base
      @client_base ||= client_settings
    end

    def client_settings
      Savon.client(global_options) do |globals|
        globals.endpoint clean_endpoint
        globals.namespace VERTEX_NAMESPACE
        globals.convert_request_keys_to :camelcase
        globals.env_namespace :soapenv
        globals.namespace_identifier :urn
        globals.open_timeout open_timeout if open_timeout.present?
        globals.read_timeout read_timeout if read_timeout.present?
      end
    end

    def config
      @config ||= VertexClient.configuration
    end

    def resource_config
      config.resource_config[@resource_key] || {}
    end

    def call_with_circuit_if_available
      if VertexClient.circuit
        VertexClient.circuit.run { yield }
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

    def timeout_scaling_factor
      resource_config[:timeout_scaling_factor] || config.timeout_scaling_factor
    end

    def clean_endpoint
      URI.join(config.soap_api, @endpoint).to_s
    end

    def read_timeout
      resource_config[:read_timeout] || config.read_timeout
    end

    def open_timeout
      resource_config[:open_timeout] || config.open_timeout
    end

    def global_options
      resource_config[:global_options] || config.global_options
    end
  end
end
