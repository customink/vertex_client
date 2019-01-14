module VertexClient
  class TaxAreaPayload < Payload
    ENDPOINT      = 'LookupTaxAreas70'.freeze
    NAME          = 'tax_area'.freeze
    RESPONSE_TYPE = TaxAreaResponse

    def transform
      self
    end

    def output
      {
        tax_area_lookup: {
          postal_address: transform_customer(@input)[:destination]
        }
      }
    end
  end
end
