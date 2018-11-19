module VertexClient
  class Configuration
    attr_accessor :trusted_id, :soap_api

    def initialize
      @trusted_id = ENV['VERTEX_TRUSTED_ID']
      @soap_api   = ENV['VERTEX_SOAP_API']
    end
  end
end
