# frozen_string_literal: true

require_relative 'invoice'
require_relative '../payloads/distribute_tax'
require_relative '../responses/distribute_tax'

module VertexClient
  module Resources
    class DistributeTax < Invoice
    end
  end
end
