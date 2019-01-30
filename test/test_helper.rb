$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'circuitbox'
require "simplecov"
require "dotenv/load"
require "vertex_client"
require "minitest/autorun"
require "vcr"
require 'byebug'
require "mocha/minitest"
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
            # tax_area_id: 330612010,
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

      let(:distribute_tax_params) do
        params = working_quote_params.dup
        line_item = params[:line_items][1]
        line_item[:total_tax] = "5.00"
        line_item[:customer] = {
          address_1: "2910 District Ave #300",
          city: "Fairfax",
          state: "VA",
          postal_code: "22031"
        }
        params[:line_items] = [line_item]
        params
      end

      let(:quotation_fallback_params) do
        params = working_quote_params.dup
        line_item = params[:line_items].first
        params[:line_items] = [line_item]
        params[:customer][:tax_area_id] = '330612010'
        params
      end

      let(:tax_area_params) do
        {
          address_1: '2910 District Ave #300',
          city: 'Fairfax',
          state: 'VA',
          postal_code: '22031'
        }
      end

      let(:tax_exempt_params) do
        {
          customer: {
            is_tax_exempt:  true,
            address_1:      '2910 District Ave',
            address_2:      'Ste. 300',
            city:           'Fairfax',
            state:          'VA',
            postal_code:    '22031'
          },
          date: '2018-11-30',
          document_number: 'tax-exempt-31337',
          line_items: [
            {
              product_code:   '4600',
              product_class:  '53103000',
              quantitiy:      10,
              price:          '50.00'
            }
          ],
          seller: {
            company: "CustomInk"
          },
        }
      end

      let(:quotation_with_location_code_params) do
        {
          customer: {
            address_1: "11 Wall Street",
            city: "New York",
            state: "NY",
            postal_code: '10005'
          },
          date: '2018-11-30',
          document_number:  'location-code-1',
          location_code:    'store_25',
          line_items: [
            {
              product_code:   '4600',
              product_class:  '53103000',
              quantitiy:      10,
              price:          '50.00'
            }
          ],
          seller: {
            company: "CustomInkStores"
          },
        }
      end

      let(:expected_payload_output) do
        {
          :@transactionType=>"SALE",
          :line_item=> [
            {
              :@lineItemNumber=>1,
              :@taxDate=>"2018-11-15",
              :customer=> {
                :destination=> {
                  # :@taxAreaId => 330612010,
                  :street_address_1=>"11 Wall Street",
                  :city=>"New York",
                  :main_division=>"NY",
                  :postal_code=>"10005",
                  :country=>"US"
                }
              },
              seller: {
                company: "CustomInk"
              },
              :product=> {
                :@productClass=>"53103000",
                content!: "4600"
              },
              :quantity=>7,
              :extended_price=>"35.50"
            },
            {
              :@lineItemNumber=>2,
              :@taxDate=>"2018-11-14",
              :customer=> {
                :destination=> {
                  :street_address_1=>"2910 District Ave #300",
                  :city=>"Fairfax",
                  :main_division=>"VA",
                  :postal_code=>"22031",
                  :country=>"US"
                }
              },
              :seller=> {
                :company=>"CustomInk"
              },
              :product=> {
                :@productClass=>"53103000",
                content!: "5300"
              },
              :quantity=>4,
              :extended_price=>"25.40"
            }
          ]
        }
      end
    end
  end
end
