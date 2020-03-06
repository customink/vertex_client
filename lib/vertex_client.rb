# frozen_string_literal: true

require 'savon'
require 'active_support/all'
require_relative 'vertex_client/configuration'
require_relative 'vertex_client/resources/distribute_tax'
require_relative 'vertex_client/resources/invoice'
require_relative 'vertex_client/resources/quotation'
require_relative 'vertex_client/resources/tax_area'
require_relative 'vertex_client/version'
require_relative 'vertex_client/railtie' if defined?(Rails)

module VertexClient
  class << self
    attr_writer :configuration

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
      Resources::Quotation.new(payload).result
    end

    def invoice(payload)
      Resources::Invoice.new(payload).result
    end

    def distribute_tax(payload)
      Resources::DistributeTax.new(payload).result
    end

    def tax_area(payload)
      Resources::TaxArea.new(payload).result
    end
  end

  class Error < StandardError; end
  class ValidationError < Error; end
  class ServerError < Error; end
end
