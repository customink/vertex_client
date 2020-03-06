# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/resources/base'
require 'vertex_client/responses/base'
require 'vertex_client/payloads/base'

describe VertexClient::Resources::Base do
  module VertexClient
    module Resources
      class MyTest < VertexClient::Resources::Base
        ENDPOINT = 'MyEndPoint'
      end
    end

    module Payloads
      class MyTest < VertexClient::Payloads::Base
        def validate!; end

        def body
          @params
        end
      end
    end

    module Responses
      class MyTest < VertexClient::Responses::Base; end
    end
  end

  subject { VertexClient::Resources::MyTest.new({ test: :ok }) }

  describe 'initialize' do
    it 'sets @payload with a new instance of payload_type' do
      assert_kind_of VertexClient::Payloads::MyTest, subject.instance_variable_get(:@payload)
    end
  end

  describe 'connection' do
    it 'is a connection initialized with ENDPOINT' do
      VertexClient::Connection.expects(:new).with(VertexClient::Resources::MyTest::ENDPOINT, :my_test)
      subject.send(:connection)
    end
  end

  describe 'result' do
    describe 'when response is set' do
      before { subject.stubs(:response).returns({ test: :ok }) }

      it 'calls formatted_response' do
        subject.expects(:formatted_response)
        subject.result
      end
    end

    describe 'when response is not set' do
      before { subject.stubs(:response).returns(nil) }

      it 'calls fallback_response' do
        subject.expects(:fallback_response)
        subject.result
      end
    end
  end

  describe 'formatted_response' do
    it 'returns a new response of the proper type' do
      subject.expects(:response).returns(test: :ok)
      VertexClient::Responses::MyTest.expects(:new).with(test: :ok)
      subject.send(:formatted_response)
    end
  end
end
