require 'test_helper'

describe VertexClient::Response::Base do
  class VertexClient::Response::MyClass < VertexClient::Response::Base; end

  let(:vertex_my_class_response) do
    OpenStruct.new(body: {
      vertex_envelope: {
        my_class_response: {
          some_values: {
            test: :ok
          }
        }
      }
    })
  end

  let(:response) { VertexClient::Response::MyClass.new(vertex_my_class_response) }

  describe 'response_key' do
    it 'is the demodulized class name plus _response' do
      assert_equal :my_class_response, response.send(:response_key)
    end
  end

  describe 'initialization' do
    it 'sets @body from the response with indifferent access' do
      body = response.instance_variable_get(:@body)
      assert_equal :ok, body[:some_values][:test]
      assert_equal :ok, body['some_values']['test']
    end
  end
end
