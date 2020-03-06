# frozen_string_literal: true

require_relative 'rates'

module VertexClient
  # This class is responsible for tracking the configuration of the VertexClient
  # By default the class will load the correct environment variables, but also provides a means to override the
  # settings manually in case no environment variables are present.
  class Configuration
    attr_accessor :trusted_id
    attr_writer :soap_api, :open_timeout, :read_timeout, :resource_config

    # Creates a new instance of the class, and automatically extracts the required Vertex configuration from the
    # ENV variable if available.
    def initialize
      @trusted_id = ENV.fetch('VERTEX_TRUSTED_ID') { '' }
      @soap_api   = ENV.fetch('VERTEX_SOAP_API') { '' }
    end

    # Returns the SOAP API Endpoint URL
    #
    # @return String the SOAP API endpoint URL.
    def soap_api
      @soap_api.gsub(%r{/+$}, '') + '/'
    end

    # Returns the resource configuration
    #
    # @return Hash The resource configuration
    def resource_config
      @resource_config || {}
    end

    # Returns the fallback rates for Vertex in case the actual rates cannot be retrieved from the service.
    #
    # @return Hash The fallback rates for Vertex
    def fallback_rates
      RATES
    end

    # Returns the open timeout in seconds stored in the configuration, or the default value of +5+ seconds.
    #
    # @return Number the open timeout in seconds.
    def open_timeout
      @open_timeout || 5
    end

    # Returns the read timeout in seconds stored in the configuration, or the default value of +5+ seconds.
    #
    # @return Number The read timeout in seconds.
    def read_timeout
      @read_timeout || 5
    end
  end
end
