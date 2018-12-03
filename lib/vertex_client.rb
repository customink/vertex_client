require 'vertex_client/version'
require 'vertex_client/railtie' if defined?(Rails)

require 'active_support/all'
require 'savon'

module VertexClient

  autoload :Configuration,        'vertex_client/configuration'
  autoload :Connection,           'vertex_client/connection'
  autoload :DistributeTaxPayload, 'vertex_client/distribute_tax_payload'
  autoload :Fallbacks,            'vertex_client/fallbacks'
  autoload :FallbackResponse,     'vertex_client/fallback_response'
  autoload :InvoicePayload,       'vertex_client/invoice_payload'
  autoload :Payload,              'vertex_client/payload'
  autoload :PayloadValidator,     'vertex_client/payload_validator'
  autoload :Response,             'vertex_client/response'
  autoload :ResponseLineItem,     'vertex_client/response_line_item'
  autoload :QuotationPayload,     'vertex_client/quotation_payload'

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
      Connection.new.request(QuotationPayload.new(payload))
    end

    def invoice(payload)
      Connection.new.request(InvoicePayload.new(payload))
    end

    def distribute_tax(payload)
      Connection.new.request(DistributeTaxPayload.new(payload))
    end

    def circuit
      return unless configuration.circuit_config && defined?(Circuitbox)
      Circuitbox.circuit(
        Configuration::CIRCUIT_NAME,
        configuration.circuit_config
      )
    end
  end

  class Error < StandardError; end
  class PayloadValidationError < Error; end
  class ServerValidationError < Error; end

end
