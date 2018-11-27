module VertexClient
  class DistributeTaxPayload < InvoicePayload
    NAME = 'distribute_tax'.freeze

    def transform_line_item(line_item, number, defaults)
      remove_nils(super(line_item, number, defaults).merge(
        input_total_tax: line_item[:total_tax]
      ))
    end
  end
end
