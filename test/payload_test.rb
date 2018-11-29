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
    assert_raises VertexClient::Error do
      input = working_quote_params
      input.delete(:document_number)
      VertexClient::InvoicePayload.new(input).transform
    end
  end

  it 'raises if the document_number is too long' do
    assert_raises VertexClient::Error do
      input = working_quote_params
      input[:document_number] = 'a-document-number-that-is-too-many-characters'
      VertexClient::InvoicePayload.new(input).transform
    end
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
            :@productClass=>"53103000"
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
            :@productClass=>"53103000"
          },
          :quantity=>4,
          :extended_price=>"25.40"
        }
      ]
    }
  end
end
