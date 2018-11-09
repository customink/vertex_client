module VertexClient
  class Configuration
    attr_accessor :trusted_id

    def initialize
      @trusted_id = ENV['VERTEX_TRUSTED_ID']
    end
  end
end
