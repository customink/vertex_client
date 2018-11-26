require 'rails'
require 'rails/generators'
module VertexClient
  class InstallGenerator < Rails::Generators::Base
    desc 'Installs the vertex_client gem with base configuration'
    source_root File.expand_path('../templates', __FILE__)

    def create_intitializer
      template 'initializer.rb.erb', 'config/initializers/vertex_client.rb'
    end
  end
end
