$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "simplecov"
require "dotenv/load"
require "vertex_client"
require "minitest/autorun"
require "vcr"
SimpleCov.start

VertexClient.configuration # make sure the client is configured

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('{VERTEX_TRUSTED_ID}') { VertexClient.configuration.trusted_id }
  config.filter_sensitive_data('{VERTEX_SOAP_API}')   { VertexClient.configuration.soap_api }
end


module TestInput
  def test_input
    {
      date: '2018-11-15',
      discount: "5.40",
      customer: {
        code: "inky@customink.com",
        address_1: "11 Wall Street",
        city: "New York",
        state: "NY",
        postal_code: '10005'
      },
      seller: {
        company: "CustomInk"
      },
      line_items: [
        {
          product_code: "t-shirts",
          quantity: 7,
          price: "35.50",
        },
        {
          product_code: "t-shirts",
          quantity: 4,
          price: "25.40",
          date: '2018-11-14',
          discount: "2.23",
          seller: {
            company: "CustomInkStores"
          },
          customer: {
            code: "prez@customink.com",
            address_1: "1600 Pennsylvania Ave NW",
            city: "Washington",
            state: "DC",
            postal_code: '20500'
          }
        }
      ]
    }
  end
end
