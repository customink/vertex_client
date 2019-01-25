require 'vertex_client/version'
require 'vertex_client/railtie' if defined?(Rails)
require 'active_support/all'
require 'savon'

module VertexClient

  autoload :Configuration,        'vertex_client/configuration'
  autoload :Connection,           'vertex_client/connection'
  autoload :RATES,                'vertex_client/rates'

  module Utils
    autoload :AdjustmentAllocator, 'vertex_client/utils/adjustment_allocator'
  end

  module Payload
    autoload :Base,                 'vertex_client/payloads/base'
    autoload :DistributeTax,        'vertex_client/payloads/distribute_tax'
    autoload :Invoice,              'vertex_client/payloads/invoice'
    autoload :Quotation,            'vertex_client/payloads/quotation'
    autoload :QuotationFallback,    'vertex_client/payloads/quotation_fallback'
    autoload :TaxArea,              'vertex_client/payloads/tax_area'
  end

  module Resource
    autoload :Base,                 'vertex_client/resources/base'
    autoload :DistributeTax,        'vertex_client/resources/distribute_tax'
    autoload :Invoice,              'vertex_client/resources/invoice'
    autoload :Quotation,            'vertex_client/resources/quotation'
    autoload :TaxArea,              'vertex_client/resources/tax_area'
  end

  module Response
    autoload :Base,                 'vertex_client/responses/base'
    autoload :DistributeTax,        'vertex_client/responses/distribute_tax'
    autoload :Invoice,              'vertex_client/responses/invoice'
    autoload :LineItem,             'vertex_client/responses/line_item'
    autoload :Quotation,            'vertex_client/responses/quotation'
    autoload :QuotationFallback,    'vertex_client/responses/quotation_fallback'
    autoload :TaxArea,              'vertex_client/responses/tax_area'
    autoload :TaxAreaFallback,      'vertex_client/responses/tax_area_fallback'
  end

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
      Resource::Quotation.new(payload).result
    end

    def invoice(payload)
      Resource::Invoice.new(payload).result
    end

    def distribute_tax(payload)
      Resource::DistributeTax.new(payload).result
    end

    def tax_area(payload)
      Resource::TaxArea.new(payload).result
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
  class ValidationError < Error; end
  class ServerError < Error; end
end
