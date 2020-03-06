# frozen_string_literal: true

require 'test_helper'
require 'generators/install/install_generator'

module Install
  class InstallGeneratorTest < Rails::Generators::TestCase
    tests VertexClient::Install::InstallGenerator
    destination '/tmp'
    setup :prepare_destination

    test 'generator runs' do
      run_generator
      assert_file 'config/initializers/vertex_client.rb'
    end
  end
end
