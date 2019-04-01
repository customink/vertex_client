require 'test_helper'

describe VertexClient::Resource::Base do
  class VertexClient::Resource::MyTest  < VertexClient::Resource::Base
    ENDPOINT = 'MyEndPoint'.freeze
  end
  class VertexClient::Payload::MyTest   < VertexClient::Payload::Base
    def validate!
    end

    def body
      @params
    end
  end
  class VertexClient::Response::MyTest  < VertexClient::Response::Base; end;

  let(:resource) { VertexClient::Resource::MyTest.new({ test: :ok })}

  describe 'initialize' do
    it 'sets @payload with a new instance of payload_type' do
      assert_kind_of VertexClient::Payload::MyTest, resource.instance_variable_get(:@payload)
    end
  end

  describe 'connection' do
    it 'is a connection initialized with ENDPOINT' do
      VertexClient::Connection.expects(:new).with(VertexClient::Resource::MyTest::ENDPOINT, :my_test)
      resource.send(:connection)
    end
  end

  describe 'result' do
    describe 'when response is set' do
      before do
        resource.stubs(:response).returns({ test: :ok })
      end
      it 'calls formatted_response' do
        resource.expects(:formatted_response)
        resource.result
      end
    end

    describe 'when response is not set' do
      before do
        resource.stubs(:response).returns(nil)
      end
      it 'calls fallback_response' do
        resource.expects(:fallback_response)
        resource.result
      end
    end
  end

  describe 'formatted_response' do
    it 'returns a new response of the proper type' do
      resource.expects(:response).returns({test: :ok})
      VertexClient::Response::MyTest.expects(:new).with({test: :ok})
      resource.send(:formatted_response)
    end
  end
end
