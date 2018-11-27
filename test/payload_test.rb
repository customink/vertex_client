require "test_helper"

describe VertexClient::Payload do
  include TestInput

  it 'transforms the input hash for invoice' do
    assert_equal(VertexClient::Payload.new(
      working_quote_params,
      VertexClient::QUOTATION
    ).transform.output, expected_output)
  end

  it 'includes the date and document number for invoice' do
    output = VertexClient::Payload.new(
      working_quote_params,
      VertexClient::INVOICE
    ).transform.output
    assert_equal output[:'@documentNumber'], 'test123'
    assert_equal output[:'@documentDate'],   '2018-11-15'
  end

  it 'raises if the document_number is not included for invoice' do
    assert_raises VertexClient::Error do
      input = working_quote_params
      input.delete(:document_number)
      VertexClient::Payload.new(input, VertexClient::INVOICE).transform
    end
  end

  it 'raises if the document_number is too long' do
    assert_raises VertexClient::Error do
      input = working_quote_params
      input[:document_number] = 'a-document-number-that-is-too-many-characters'
      VertexClient::Payload.new(input, VertexClient::INVOICE).transform
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
          :product=>"t-shirts",
          :quantity=>7,
          :extended_price=>"35.50"
        },
        {
          :@lineItemNumber=>2,
          :@taxDate=>"2018-11-14",
          :customer=> {
            :destination=> {
              :street_address_1=>"1600 Pennsylvania Ave NW",
              :city=>"Washington",
              :main_division=>"DC",
              :postal_code=>"20500"
            }
          },
          :seller=> {
            :company=>"CustomInk"
          },
          :product=>"t-shirts",
          :quantity=>4,
          :extended_price=>"25.40"
        }
      ]
    }
  end
end
