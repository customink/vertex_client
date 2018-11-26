module VertexClient
  class Railtie < Rails::Railtie
    generators do
      require 'generators/install/install_generator'
    end
  end
end
