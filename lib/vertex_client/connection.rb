# frozen_string_literal: true

module VertexClient
  # This class represents the Savon connection to the SOAP endpoint of Vertex.
  # Because this gem needs to be used in a production environment, WSDL browsing is disabled in the code
  # to ensure performance and safety in the production environment.
  class Connection
    VERTEX_NAMESPACE = 'urn:vertexinc:o-series:tps:7:0'
    ERROR_MESSAGE = 'The Vertex API returned an error or is unavailable'

    def initialize(endpoint, resource_key = nil)
      @endpoint = endpoint
      @resource_key = resource_key
    end

    def request(payload)
      client.call(:vertex_envelope, message: shell_with_auth.merge(payload))
    end

    def client
      @client ||= Savon.client do |globals|
        globals.endpoint clean_endpoint
        globals.namespace VERTEX_NAMESPACE
        globals.convert_request_keys_to :camelcase
        globals.env_namespace :soapenv
        globals.namespace_identifier :urn
        globals.open_timeout open_timeout
        globals.read_timeout read_timeout
      end
    end

    private

    def config
      @config ||= VertexClient.configuration
    end

    def resource_config
      config.resource_config[@resource_key] || {}
    end

    def shell_with_auth
      {
        login: { trusted_id: @config.trusted_id }
      }
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
  end
end
