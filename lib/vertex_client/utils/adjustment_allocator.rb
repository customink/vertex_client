# frozen_string_literal: true

module VertexClient
  module Utils
    class AdjustmentAllocator
      def initialize(adjustment, weights)
        @adjustment = adjustment
        @weights    = weights
      end

      def allocate
        return [] if weights.empty? && @adjustment.zero?

        validate!
        allocations, remainders = allocations_with_remainders.transpose
        remaining_adjustment    = adjustment_in_cents - allocations.sum
        deserving_indices       = remainders.each_with_index
                                            .sort_by { |remainder, i| [remainder, i] }
                                            .map { |_r, i| i }
                                            .last(remaining_adjustment)
        allocations.each_with_index.map do |allocation, i|
          deserving_indices.include?(i) ? cents_to_dollars(allocation + 1) : cents_to_dollars(allocation)
        end
      end

      private

      ADJUSTMENT_ERROR = 'adjustment must not be more precise than two decimal places (eg: 2.14 or 0.05)'
      WEIGHTS_ERROR    = 'all weights must be a non-negative number, and must not total zero'

      def adjustment_format_valid?
        adjustment.is_a?(Numeric) && (dollars_to_cents(adjustment) == adjustment * 100)
      end

      def adjustment_in_cents
        dollars_to_cents(adjustment)
      end

      def allocations_with_remainders
        weights.map do |weight|
          (adjustment_in_cents * weight).divmod(weights_total)
        end
      end

      def cents_to_dollars(cents)
        cents / 100.to_d
      end

      def dollars_to_cents(dollars)
        (dollars * 100).to_i
      end

      def validate!
        raise VertexClient::ValidationError, ADJUSTMENT_ERROR unless adjustment_format_valid?
        raise VertexClient::ValidationError, WEIGHTS_ERROR unless weights_format_valid?
      end

      def weights_format_valid?
        weights.all? { |weight| weight.is_a?(Numeric) && weight >= 0 } && !weights_total.zero?
      end

      def weights_total
        weights.sum
      end

      attr_reader :adjustment, :weights
    end
  end
end
