require 'test_helper'

describe 'Integration' do
  include TestInput

  after do
    VertexClient.reconfigure!
  end

  describe 'for US customer' do
    it 'does a quotation' do
      VCR.use_cassette('quotation', :match_requests_on => []) do
        response = VertexClient.quotation(working_quote_params)
        assert_equal 1.52, response.total_tax
        assert_equal '4600', response.line_items.first.product.product_code
        assert_equal '53103000', response.line_items.first.product.product_class
      end
    end

    it 'does a quotation for a quote with a single line_item' do
      VCR.use_cassette('single_line_item_quotation', :match_requests_on => []) do
        response = VertexClient.quotation(single_line_item_quotation_params)
        assert_equal 1.52, response.line_items.first.total_tax
      end
    end
  end

  describe 'for EU customer' do
    it 'does a quotation' do
      VCR.use_cassette('eu_quotation', :match_requests_on => []) do
        response = VertexClient.quotation(working_eu_quote_params)
        assert_equal 0.0, response.total_tax
        assert_equal '4600', response.line_items.first.product.product_code
        assert_equal '53103000', response.line_items.first.product.product_class
      end
    end

    it 'does a quotation for a quote with a single line_item' do
      VCR.use_cassette('single_line_item_eu_quotation', :match_requests_on => []) do
        response = VertexClient.quotation(single_line_item_eu_quotation_params)
        assert_equal 0.0, response.line_items.first.total_tax
      end
    end
  end

  it 'does an invoice' do
    VCR.use_cassette('invoice', :match_requests_on => []) do
      response = VertexClient.invoice(working_quote_params)
      assert_equal 1.52, response.total_tax
    end
  end

  it 'does distribute_tax' do
    VCR.use_cassette('distribute_tax', :match_requests_on => []) do
      VertexClient.distribute_tax(distribute_tax_params)
    end
  end

  it 'does tax_area' do
    VCR.use_cassette('tax_area', :match_requests_on => []) do
      assert_equal '470590000', VertexClient.tax_area(tax_area_params).tax_area_id
    end
  end

  it 'does tax_area for results with multiple responses' do
    VCR.use_cassette('tax_area_multiple', :match_requests_on => []) do
      assert_equal '420130010', VertexClient.tax_area({
        address_1: '126487 N Bridge Rd',
        city: 'Aberdeen',
        state: 'SD',
        postal_code: '57401'
      }).tax_area_id
    end
  end

  it 'uses circuit if it is available' do
    VertexClient.reconfigure! do |config|
      config.circuit_config = {}
    end

    VCR.use_cassette('quotation', :match_requests_on => []) do
      VertexClient.quotation(working_quote_params)
    end
  end

  describe 'supports is_tax_exempt on customer' do
    it 'does a tax_exempt quote' do
      VCR.use_cassette('tax_exempt/quotation', :match_requests_on => []) do
        response = VertexClient.quotation(tax_exempt_params)
        assert_equal 0.0, response.total_tax
        assert_equal 50.0, response.total
      end
    end

    it 'does a tax_exempt invoice' do
      VCR.use_cassette('tax_exempt/invoice', :match_requests_on => []) do
        response = VertexClient.invoice(tax_exempt_params)
        assert_equal 0.0, response.total_tax
        assert_equal 50.0, response.total
      end
    end

    it 'does a tax_exempt distribute_tax' do
      # Though I'm not sure why we would ever do this... ¯\_(ツ)_/¯
      VCR.use_cassette('tax_exempt/distribute_tax', :match_requests_on => []) do
        tax_exempt_params[:line_items][0][:total_tax] = '0.00'
        response = VertexClient.distribute_tax(tax_exempt_params)
        assert_equal 0.0, response.total_tax
        assert_equal 50.0, response.total
      end
    end

    describe 'supports location_code' do
      it 'does a location_code quote' do
        VCR.use_cassette('location_code/quotation', :match_requests_on => []) do
          response = VertexClient.quotation(quotation_with_location_code_params)
          assert_equal 0.0, response.total_tax
          assert_equal 50.0, response.total
        end
      end

      it 'does a location_code invoice' do
        VCR.use_cassette('location_code/invoice', :match_requests_on => []) do
          response = VertexClient.invoice(quotation_with_location_code_params)
          assert_equal 0.0, response.total_tax
          assert_equal 50.0, response.total
        end
      end

      it 'does a location_code distribute_tax' do
        VCR.use_cassette('location_code/distribute_tax', :match_requests_on => []) do
          quotation_with_location_code_params[:line_items][0][:total_tax] = '0.00'
          response = VertexClient.distribute_tax(quotation_with_location_code_params)
          assert_equal 0.0, response.total_tax
          assert_equal 50.0, response.total
        end
      end
    end
  end

  it 'creates a fallback response for quotation when the circuit is open' do
    VertexClient.configuration.circuit_config = {}
    VertexClient.circuit.send(:open!)
    response = VertexClient.quotation(working_quote_params)
    VertexClient.circuit.send(:close!)
    assert_kind_of VertexClient::Response::QuotationFallback, response
  end

  it 'creates a fallback response for quotation when Vertex returns an error' do
    VCR.use_cassette('circuit_breaker') do
      assert_kind_of VertexClient::Response::QuotationFallback,
        VertexClient.quotation(working_quote_params)
    end
  end

  it 'raises if the circuit is open on invoice' do
    VertexClient.configuration.circuit_config = {}
    VertexClient.circuit.send(:open!)
    assert_raises VertexClient::ServerError do
      VertexClient.invoice(working_quote_params)
    end
    VertexClient.circuit.send(:close!)
  end

  it 'raises if theres an error on invoice and the circuit is closed' do
    VertexClient.configuration.circuit_config = {}
    resource = VertexClient::Resource::Invoice.new( working_quote_params )
    raises_expection = proc { raise Savon::Error.new('something went wrong') }
    resource.send(:connection).send(:client).stub(:call, raises_expection) do
      assert_raises VertexClient::ServerError do
        resource.result
      end
    end
  end

  it 'raises if theres an error on invoice and the circuit is missing' do
    assert_nil VertexClient.circuit
    resource = VertexClient::Resource::Invoice.new( working_quote_params )
    raises_expection = proc { raise Savon::Error.new('something went wrong') }
    resource.send(:connection).send(:client).stub(:call, raises_expection) do
      assert_raises VertexClient::ServerError do
        resource.result
      end
    end
  end

  it 'raises if the circuit is open on distribute tax' do
    VertexClient.configuration.circuit_config = {}
    VertexClient.circuit.send(:open!)
    assert_raises VertexClient::ServerError do
      VertexClient.distribute_tax(distribute_tax_params)
    end
    VertexClient.circuit.send(:close!)
  end

  it 'raises if theres an error on distribute tax and the circuit is closed' do
    VertexClient.configuration.circuit_config = {}
    resource = VertexClient::Resource::DistributeTax.new(distribute_tax_params)
    raises_expection = proc { raise Savon::Error.new('something went wrong') }
    resource.send(:connection).send(:client).stub(:call, raises_expection) do
      assert_raises VertexClient::ServerError do
        resource.result
      end
    end
  end

  it 'raises if theres an error on distribute tax and the circuit is missing' do
    assert_nil VertexClient.circuit
    resource = VertexClient::Resource::DistributeTax.new(distribute_tax_params)
    raises_expection = proc { raise Savon::Error.new('something went wrong') }
    resource.send(:connection).send(:client).stub(:call, raises_expection) do
      assert_raises VertexClient::ServerError do
        resource.result
      end
    end
  end
end
