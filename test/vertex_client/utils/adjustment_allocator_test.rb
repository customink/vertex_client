# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/utils/adjustment_allocator'

describe VertexClient::Utils::AdjustmentAllocator do
  let(:adjustment)          { BigDecimal('1234.56') }
  let(:weights_as_prices)   { [BigDecimal('310'), BigDecimal('350'), BigDecimal('200'), BigDecimal('140')] }
  let(:weights_as_ratios)   { [31, 35, 20, 14] }
  let(:expected_allocation) { [BigDecimal('382.71'), BigDecimal('432.1'), BigDecimal('246.91'), BigDecimal('172.84')] }

  describe '#allocate' do
    describe 'adjustment validation' do
      it 'raises if adjustment is a string' do
        assert_raises VertexClient::ValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment.to_s, weights_as_prices).allocate
        end
      end

      it 'raises if adjustment has more than two decimal places' do
        assert_raises VertexClient::ValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(BigDecimal('1234.567'), weights_as_prices).allocate
        end
      end
    end

    describe 'weights validation' do
      it 'raises if any of the weights is negative' do
        assert_raises VertexClient::ValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment, [-1.0, 2.0, 3.0]).allocate
        end
      end

      it 'raises if the weights total to zero' do
        assert_raises VertexClient::ValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment, [0, 0, 0]).allocate
        end
      end

      it 'raises if any of the weights is a string' do
        assert_raises VertexClient::ValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment, [1.0, 2.0, '3']).allocate
        end
      end
    end

    it 'properly allocates a postive adjustment (ie: service charge)' do
      assert_equal(
        expected_allocation,
        VertexClient::Utils::AdjustmentAllocator.new(adjustment, weights_as_prices).allocate
      )
    end

    it 'properly allocates a negative adjustment (ie: discount)' do
      discount            = adjustment * -1
      discount_allocation = expected_allocation.map { |weight| weight * -1 }

      assert_equal(
        discount_allocation,
        VertexClient::Utils::AdjustmentAllocator.new(discount, weights_as_prices).allocate
      )
    end

    it 'properly allocates an adjustment regardless of whether weights are given as prices or as ratios' do
      price_allocation = VertexClient::Utils::AdjustmentAllocator.new(adjustment, weights_as_prices).allocate
      ratio_allocation = VertexClient::Utils::AdjustmentAllocator.new(adjustment, weights_as_ratios).allocate
      assert_equal price_allocation, ratio_allocation
    end

    it 'handles an empty array of weights if the adjustment amount is 0' do
      assert_empty(VertexClient::Utils::AdjustmentAllocator.new(0, []).allocate)
    end

    describe 'allocating remainder pennies perfectly' do
      let(:one_penny)           { BigDecimal('0.01') }
      let(:two_pennies)         { BigDecimal('0.02') }
      let(:three_pennies)       { BigDecimal('0.03') }

      # on first pass, each one gets 0 pennies and has a remainder of $0.006.
      # 5-way tie on the remainder, so the last three will each get one
      it 'assigns remainder pennies, breaking ties by going with the last' do
        assert_equal(
          [0, 0, one_penny, one_penny, one_penny],
          VertexClient::Utils::AdjustmentAllocator.new(
            three_pennies,
            [1.0, 1.0, 1.0, 1.0, 1.0]
          ).allocate
        )
      end

      # 2.0 weight wins for the first remainder penny.
      # Then, after 3-way second place tie for $0.004,
      # the last one gets the penny
      it 'assigns remainder pennies, breaking second place ties' do
        assert_equal(
          [0, 0, one_penny, one_penny],
          VertexClient::Utils::AdjustmentAllocator.new(
            two_pennies,
            [1.0, 1.0, 2.0, 1.0]
          ).allocate
        )
      end

      # 6.0 gets a penny outright. Then all have remainder of $0.002
      # To break tie, we give the extra penny to the last.
      it 'assigns remainder pennies, regardless of pennies already assigned' do
        assert_equal(
          [0, 0, 0, 0, two_pennies],
          VertexClient::Utils::AdjustmentAllocator.new(
            two_pennies,
            [1.0, 1.0, 1.0, 1.0, 6.0]
          ).allocate
        )
      end
    end
  end
end
