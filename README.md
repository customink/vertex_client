# VertexClient

[![CircleCI](https://circleci.com/gh/customink/vertex_client.svg?style=svg&circle-token=ccfd7815662866d32b9173a55820d897b162220f)](https://circleci.com/gh/customink/vertex_client)
[![Maintainability](https://api.codeclimate.com/v1/badges/5f18a48fa18ddfb942f4/maintainability)](https://codeclimate.com/github/customink/vertex_client/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5f18a48fa18ddfb942f4/test_coverage)](https://codeclimate.com/github/customink/vertex_client/test_coverage)
[![Issue Count](https://codeclimate.com/repos/5c33a0c73c23337184000c98/badges/5f18a48fa18ddfb942f4/issue_count.svg)](https://codeclimate.com/repos/5c33a0c73c23337184000c98/feed)

The Vertex Client Ruby Gem provides an interface to integrate with _Vertex SMB_ which is also known as [Vertex Cloud Indirect Tax](https://www.vertexinc.com/solutions/products/vertex-cloud-indirect-tax).

## Usage

### Quotation

```ruby
response = VertexClient.quotation(
  # The top level transaction date for all line items.
  date: "2018-11-15",
  # Optional delivery term to specify correct pricing all line items.
  delivery_term: "DAP",
  # The top level customer for all line items.
  customer: {
    code: "inky@customink.com",
    address_1: "11 Wall Street",
    address_2: "#300",
    city: "New York",
    state: "NY",
    postal_code: "10005",
    # Optional tax_exempt status for customer
    is_tax_exempt: true,

    # Optional tax_area_id for customer location
    tax_area_id: "330612010"
  },
  # The top level seller for all line items.
  seller: {
    company: "CustomInk",
  },
  line_items: [
    {
      # Internal product ID or code
      product_code: "4600",
      # Mapped product class, or "commodity code", in Vertex Cloud
      product_class: "123456",
      quantity: 7,
      # Total price of this line item
      price: "35.50"
    },
    {
      product_code: "5200",
      product_class: "123456",
      quantity: 4,
      price: "25.40",
      # Optional transaction date override for a line item.
      date: "2018-11-14",
      # Optional seller override for a line item.
      seller: {
        company: "CustomInkStores"
      },
      # Optional customer override for a line item.
      customer: {
        code: "prez@customink.com",
        address_1: "1600 Pennsylvania Ave NW",
        city: "Washington",
        state: "DC",
        postal_code: "20500"
      }
    },
    {
      product_code: "5400",
      product_class: "123456",
      quantity: 2,
      price: "35.40",
      # Optional transaction date override for a line item.
      date: "2018-11-14",
      # Optional seller override for a line item.
      seller: {
        company: "CustomInkStores",
        # Optional physical origin of a line item
        physical_origin: {
          address_1: "Prujezdna 320/62",
          address_2: "",
          city: "Praha",
          state: "",
          postal_code: "100 00",
          country: "CZ"
        }
      }
    }
  ]
)

response.total_tax #=> Total tax amount
response.total     #=> Total price plus total tax
response.subtotal  #=> Total price before tax
```

####  Location specific data (required for `:customer` and specified `:physical_origin` of `:seller` in `:line_items`)
You are required to specify a `state` or a `country`. The client will raise an error if none is specified.

##### US address example
```ruby
 customer: {
    ...
    state: "NY",
    # Optional, you don't have to explicitly specify a country once state is set
    country: "US", 
    ...
  }
```
##### Non-US address example
`state` is an optional attribute for non-US countries
```ruby
 customer: {
    ...
    country: "CZ", 
    ...
  }
```

### Invoice

Invoice is the same payload as quotation, but with one added identifier.

```ruby
VertexClient.invoice(
  # Vertex's Document Number is a unique referencial identifier for this invoice.
  document_number: "unique-identifier-1a43b",

  # ... All of the of the payload from quotation here ...
)

```

### Distribute Tax

Distribute Tax is the same payload as Invoice, but you pass `total_tax` on each line item. The `product_code` and `quantity` are optional.

```ruby
VertexClient.distribute_tax(

  # ...

  line_items: [
    {
      price: "100.00",
      total_tax: "6.00",
    }
  ]

)
```

### Tax Area
Look up the internal Vertex location identifier for a given address. Including  `tax_area_id` as part of the customer information in calls to `invoice` and `quotation` should improve performance, especially in situations where there are many destination addresses.

```ruby
response = VertexClient.tax_area(
  address_1: "11 Wall Street",
  address_2: "#300",
  city: "New York",
  state: "NY",
  postal_code: "10005"
)
response.tax_area_id # => '330612010'
```

### Adjustment Allocator

Allocates a given monetary adjustment, such as a service charge or a discount, across a given array of weights, such as line items. The `adjustment` parameter must be passed in as a positive or negative numeric dollar amount, such as `-0.56`, `7.00` or `12.34`, and the `weights` parameter must be passed in as an array of non-negative numeric values, such as `[1.23, 4.56, 7.89]` or `[1, 2, 3, 4]`, which can represent prices or ratios.

```ruby
VertexClient::Utils::AdjustmentAllocator.new(1234.56, [310.00, 350.00, 200.00, 140.00]).allocate
#=> [#<BigDecimal:7fa6bba053c0,'0.38271E3',18(36)>,
     #<BigDecimal:7fa6bba0fcd0,'0.4321E3',18(36)>,
     #<BigDecimal:7fa6bba0dfc0,'0.24691E3',18(36)>,
     #<BigDecimal:7fa6bba17b88,'0.17284E3',18(36)>]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vertex_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vertex_client

## Configuration

Configure the client's connection to Vertex using environment variables or an initializer.

### Environment Variables
The following environment variables are used to configure the client.

```
VERTEX_TRUSTED_ID=your-trusted-id
VERTEX_SOAP_API=https://connect.vertexsmb.com/vertex-ws/services/
```
### Initializer

If you are using Rails, take advantage of the included generator:

    $ bundle exec rails g vertex_client:install

Otherwise reference our [initializer template](https://github.com/customink/vertex_client/blob/master/lib/generators/install/templates/initializer.rb.erb)


## Development

This project follows Github's [Scripts to rule them all conventions][scripts-to-rule-them-all]. After cloning the app,
run the following:

    bin/bootstrap
    bin/setup
    bin/test

After pulling down changes, run the following:

    bin/update

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/customink/vertex_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VertexClient project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/customink/vertex_client/blob/master/CODE_OF_CONDUCT.md).

[scripts-to-rule-them-all]: https://github.com/github/scripts-to-rule-them-all
