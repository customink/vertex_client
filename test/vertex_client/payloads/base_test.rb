# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/payloads/base'

describe VertexClient::Payloads::Base do
  subject { VertexClient::Payloads::Base.new(test: :ok) }

  describe '#initialize' do
    it 'raises a NotImplemented Error' do
      assert_raises(NotImplementedError) { subject }
    end
  end
end
