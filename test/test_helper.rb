$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "simplecov"
require "dotenv/load"
require "vertex_client"
require "minitest/autorun"
require "vcr"
require 'byebug'
SimpleCov.start

VertexClient.configuration # make sure the client is configured

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('{VERTEX_TRUSTED_ID}') { VertexClient.configuration.trusted_id }
  config.filter_sensitive_data('{VERTEX_SOAP_API}')   { VertexClient.configuration.soap_api }
end

class FakeLogger
  def debug(_)
  end
end


module TestInput
  def self.included(base)
    base.class_eval do
      let(:working_quote_params) do
        {
          document_number: 'test123',
          date: '2018-11-15',
          customer: {
            tax_area_id: 330612010,
            address_1: "11 Wall Street",
            city: "New York",
            state: "NY",
            postal_code: '10005',
            country: 'US'
          },
          seller: {
            company: "CustomInk"
          },
          line_items: [
            {
              product_code: "4600",
              product_class: "53103000",
              quantity: 7,
              price: "35.50",
            },
            {
              product_code: "5300",
              product_class: "53103000",
              quantity: 4,
              price: "25.40",
              date: '2018-11-14',
              seller: {
                company: "CustomInk"
              },
              customer: {
                address_1: "2910 District Ave #300",
                city: "Fairfax",
                state: "VA",
                postal_code: '22031',
                country: 'US'
              }
            }
          ]
        }
      end
    end
  end
end
