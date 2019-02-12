require 'test_helper'

describe VertexClient::Payload::Base do
  class VertexClient::Payload::Dummy < VertexClient::Payload::Base
    def validate!
    end
    def body
      @params
    end
  end

  let(:payload) do
    VertexClient::Payload::Dummy.new(test: :ok)
  end

  it 'initializes' do
    VertexClient::Payload::Dummy.any_instance.expects(:validate!)
    assert_equal :ok, payload.instance_variable_get(:@params)[:test]
    assert_equal :ok, payload.instance_variable_get(:@params)['test']
  end

  describe 'transform' do
    it 'is a hash with key response_key and value form #body' do
      assert_equal :ok, payload.transform[:dummy_request][:test]
    end
  end
end
