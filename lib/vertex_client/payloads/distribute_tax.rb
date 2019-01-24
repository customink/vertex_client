module VertexClient
  module Payload
    class DistributeTax < Invoice
      def transform_line_item(line_item, number, defaults)
        remove_nils(super(line_item, number, defaults).merge(
          input_total_tax: line_item[:total_tax]
        ))
      end
    end
  end
end
