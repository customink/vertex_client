require 'vertex_client/version'
require 'vertex_client/railtie' if defined?(Rails)

require 'savon'

module VertexClient

  QUOTATION = 'quotation'.freeze
  INVOICE =   'invoice'.freeze

  autoload :Configuration, 'vertex_client/configuration'
  autoload :Connection,    'vertex_client/connection'
  autoload :Payload,       'vertex_client/payload'
  autoload :Response,      'vertex_client/response'

  class << self

    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reconfigure!
      @configuration = Configuration.new
      yield(@configuration) if block_given?
    end

    def configure
      yield(configuration)
    end

    def quotation(payload)
      Connection.new.request(QUOTATION, payload)
    end

    def invoice(payload)
      Connection.new.request(INVOICE, payload)
    end

    def circuit
      return unless configuration.circuit_config
      Circuitbox.circuit(
        Configuration::CIRCUIT_NAME,
        configuration.circuit_config
      )
    end
  end

  class Error < StandardError; end

end
