module VertexClient
  class Configuration

    CIRCUIT_NAME = 'vertex_client'.freeze
    CIRCUIT_CONFIG = {
      sleep_window:     300,
      volume_threshold: 10,
      error_threshold:  50,
      time_window:      60,
      logger: Logger.new(STDOUT),
      exceptions: [
        Savon::Error
      ]
    }.freeze

    attr_accessor :trusted_id, :soap_api, :circuit_config

    def initialize
      @trusted_id = ENV['VERTEX_TRUSTED_ID']
      @soap_api   = ENV['VERTEX_SOAP_API']
    end

    def circuit_config
      CIRCUIT_CONFIG.merge(@circuit_config) if @circuit_config
    end
  end
end
