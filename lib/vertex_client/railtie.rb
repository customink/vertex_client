module VertexClient
  class Railtie < Rails::Railtie
    config.before_initialize do |_app|
      if Rails.env.development?
        VertexClient.configure do |config|
          logger_opts = { log: true, logger: Rails.logger, log_level: :info }
          config.global_options = config.global_options.merge(logger_opts)
        end
      end
    end

    generators do
      require 'generators/install/install_generator'
    end
  end
end
