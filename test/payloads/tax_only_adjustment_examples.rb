module VertexClient::Payload::TaxOnlyAdjustmentExamples
  def it_supports_tax_only_adjustments(param_name)
    describe '@isTaxOnlyAdjustmentIndicator' do
      let(:params) { public_send param_name }

      it 'supports sending tax_only_adjustment to body' do
        params[:tax_only_adjustment] = true
        assert payload.body[:@isTaxOnlyAdjustmentIndicator]
      end

      it 'does not send tax_only_adjustment by default' do
        refute payload.body[:@isTaxOnlyAdjustmentIndicator]
      end

      it 'does not send tax_only_adjustment when set to false' do
        params[:tax_only_adjustment] = false
        refute payload.body[:@isTaxOnlyAdjustmentIndicator]
      end
    end
  end
end
