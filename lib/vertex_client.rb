require "vertex_client/version"

module VertexClient
  class << self
    attr_accessor :configuration
  end

  autoload :Configuration, 'vertex_client/configuration'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Error < StandardError; end
end
