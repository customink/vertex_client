require "test_helper"

describe VertexClient::Payload do
  include TestInput

  it 'transforms the input hash for quotation' do
    assert_equal(VertexClient::QuotationPayload.new(working_quote_params).transform.output, expected_output)
  end

  it 'includes the date and document number for invoice' do
    output = VertexClient::InvoicePayload.new(working_quote_params).transform.output
    assert_equal output[:'@documentNumber'], 'test123'
    assert_equal output[:'@documentDate'],   '2018-11-15'
  end

  it 'raises if the document_number is not included for invoice' do
    assert_raises VertexClient::ValidationError do
      input = working_quote_params
      input.delete(:document_number)
      VertexClient::InvoicePayload.new(input).transform
    end
  end

  it 'supports sending is_tax_exempt to customer' do
    working_quote_params[:customer][:is_tax_exempt] = true
    output = VertexClient::InvoicePayload.new(working_quote_params).transform.output
    assert output[:line_item][0][:customer][:@isTaxExempt]
  end

  it 'raises if state and zip code are missing' do
    params = working_quote_params
    params[:customer].delete(:postal_code)
    params[:customer].delete(:state)
    assert_raises VertexClient::ValidationError do
      VertexClient::QuotationPayload.new(params).transform
    end
  end

  it 'returns all customer lines' do
    assert_equal 2, VertexClient::Payload.new(working_quote_params).all_customer_lines.count
  end

  def expected_output
    {
      :@transactionType=>"SALE",
      :line_item=> [
        {
          :@lineItemNumber=>1,
          :@taxDate=>"2018-11-15",
          :customer=> {
            :destination=> {
              :street_address_1=>"11 Wall Street",
              :city=>"New York",
              :main_division=>"NY",
              :postal_code=>"10005"
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
              :postal_code=>"22031"
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
