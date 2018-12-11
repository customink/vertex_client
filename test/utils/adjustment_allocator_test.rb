require 'test_helper'

describe VertexClient::Utils::AdjustmentAllocator do
  let(:adjustment)          { 1234.56 }
  let(:weights_as_prices)   { [310.00, 350.00, 200.00, 140.00] }
  let(:weights_as_ratios)   { [31, 35, 20, 14] }
  let(:expected_allocation) { [382.71.to_d, 432.10.to_d, 246.91.to_d, 172.84.to_d] }

  describe '#allocate' do
    describe 'adjustment validation' do
      it 'raises if adjustment is a string' do
        assert_raises VertexClient::UtilsValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment.to_s, weights_as_prices).allocate
        end
      end

      it 'raises if adjustment is an integer' do
        assert_raises VertexClient::UtilsValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment.to_i, weights_as_prices).allocate
        end
      end

      it 'raises if adjustment has more than two decimal places' do
        assert_raises VertexClient::UtilsValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(1234.56789, weights_as_prices).allocate
        end
      end
    end

    describe 'weights validation' do
      it 'raises if any of the weights is negative' do
        assert_raises VertexClient::UtilsValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment, [-1.0, 2.0, 3.0]).allocate
        end
      end

      it 'raises if the weights total to zero' do
        assert_raises VertexClient::UtilsValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment, [0, 0, 0]).allocate
        end
      end

      it 'raises if any of the weights is a string' do
        assert_raises VertexClient::UtilsValidationError do
          VertexClient::Utils::AdjustmentAllocator.new(adjustment, [1.0, 2.0, '3']).allocate
        end
      end
    end
    
    it 'properly allocates a postive adjustment (ie: service charge)' do
      assert_equal expected_allocation, VertexClient::Utils::AdjustmentAllocator.new(adjustment, weights_as_prices).allocate
    end

    it 'properly allocates a negative adjustment (ie: discount)' do
      discount            = adjustment * -1
      discount_allocation = expected_allocation.map { |weight| weight * -1 }
      assert_equal discount_allocation, VertexClient::Utils::AdjustmentAllocator.new(discount, weights_as_prices).allocate
    end

    it 'properly allocates an adjustment regardless of whether weights are given as prices or as ratios' do
      price_allocation = VertexClient::Utils::AdjustmentAllocator.new(adjustment, weights_as_prices).allocate
      ratio_allocation = VertexClient::Utils::AdjustmentAllocator.new(adjustment, weights_as_ratios).allocate
      assert_equal price_allocation, ratio_allocation
    end
  end
end
