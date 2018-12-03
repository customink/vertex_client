require "test_helper"

describe VertexClient::Connection do
  include TestInput
  before do
    VertexClient.reconfigure!
  end

  after do
    VertexClient.reconfigure!
  end

  it 'does a quotation' do
    VCR.use_cassette("quotation", :match_requests_on => []) do
      response = VertexClient.quotation(working_quote_params)
      assert_equal response.total_tax, 1.52
    end
  end

  it 'does an invoice' do
    VCR.use_cassette("invoice", :match_requests_on => []) do
      response = VertexClient.invoice(working_quote_params)
      assert_equal response.total_tax, 1.52
    end
  end

  it 'does distribute_tax' do
    input = working_quote_params
    input[:line_items].shift # remove the first one
    input[:line_items].each do |line_item|
      line_item[:total_tax] = "5.00"
      line_item[:customer] = {
        address_1: "2910 District Ave #300",
        city: "Fairfax",
        state: "VA",
        postal_code: "22031"
      }
    end
    VCR.use_cassette("distribute_tax", :match_requests_on => []) do
      VertexClient.distribute_tax(input)
    end
  end

  it 'uses circuit if it is available' do
    VertexClient.configuration.circuit_config = {}
    VCR.use_cassette("quotation", :match_requests_on => []) do
      VertexClient.quotation(working_quote_params)
    end
  end

  describe 'supports is_tax_exempt on customer' do
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

    it 'does a tax_exempt quote' do
      VCR.use_cassette('tax_exempt/quotation', :match_requests_on => []) do
        response = VertexClient.quotation(tax_exempt_params)
        assert_equal response.total_tax, 0.0
        assert_equal response.total, 50.0
      end
    end

    it 'does a tax_exempt invoice' do
      VCR.use_cassette('tax_exempt/invoice', :match_requests_on => []) do
        response = VertexClient.invoice(tax_exempt_params)
        assert_equal response.total_tax, 0.0
        assert_equal response.total, 50.0
      end
    end

    it 'does a tax_exempt distribute_tax' do
      # Though I'm not sure why we would ever do this... ¯\_(ツ)_/¯
      VCR.use_cassette('tax_exempt/distribute_tax', :match_requests_on => []) do
        tax_exempt_params[:line_items][0][:total_tax] = '0.00'
        response = VertexClient.distribute_tax(tax_exempt_params)
        assert_equal response.total_tax, 0.0
        assert_equal response.total, 50.0
      end
    end

    describe 'supports location_code' do
      let(:location_enabled_params) do
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

      it 'does a location_code quote' do
        VCR.use_cassette('location_code/quotation', :match_requests_on => []) do
          response = VertexClient.quotation(location_enabled_params)
          assert_equal response.total_tax, 0.0
          assert_equal response.total, 50.0
        end
      end

      it 'does a locaiton_code invoice' do
        VCR.use_cassette('location_code/invoice', :match_requests_on => []) do
          response = VertexClient.invoice(location_enabled_params)
          assert_equal response.total_tax, 0.0
          assert_equal response.total, 50.0
        end
      end

      it 'does a location_code distribute_tax' do
        VCR.use_cassette('tax_exempt/distribute_tax', :match_requests_on => []) do
          tax_exempt_params[:line_items][0][:total_tax] = '0.00'
          response = VertexClient.distribute_tax(location_enabled_params)
          assert_equal response.total_tax, 0.0
          assert_equal response.total, 50.0
        end
      end
    end
  end
end
