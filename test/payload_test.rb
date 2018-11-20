require "test_helper"

describe VertexClient::Payload do
  include TestInput

  it 'transforms the input hash' do
    assert_equal VertexClient::Payload.new(test_input).transform.output, expected_output
  end

  def expected_output
    {
      :@transactionType=>"SALE",
      :line_item=> [
        {
          :@lineItemNumber=>0,
          :date=>"2018-11-15",
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
          :@lineItemNumber=>1,
          :date=>"2018-11-14",
          :customer=> {
            :destination=> {
              :street_address_1=>"1600 Pennsylvania Ave NW",
              :city=>"Washington",
              :main_division=>"DC",
              :postal_code=>"20500"
            }
          },
          :seller=> {
            :company=>"CustomInkStores"
          },
          :product=>"t-shirts",
          :quantity=>4,
          :extended_price=>"25.40",
          :discount=> {
            :discount_amount=>"2.23"
          }
        }
      ],
      :discount=> {
        :discount_amount=>"5.40"
      }
    }
  end
end
