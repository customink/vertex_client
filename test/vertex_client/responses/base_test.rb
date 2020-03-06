# frozen_string_literal: true

require 'test_helper'
require 'vertex_client/responses/base'

describe VertexClient::Responses::Base do
  class MyClass < VertexClient::Responses::Base; end

  subject { MyClass.new(vertex_my_class_response) }

  let(:vertex_my_class_response) do
    OpenStruct.new(
      body: {
        vertex_envelope: {
          my_class_response: {
            some_values: {
              test: :ok
            }
          }
        }
      }
    )
  end

  describe '#response_key' do
    it 'is the demodulized class name plus _response' do
      assert_equal :my_class_response, subject.send(:response_key)
    end
  end

  describe 'initialization' do
    let(:body) { subject.instance_variable_get(:@body) }

    it 'sets @body from the response with indifferent access' do
      assert_equal :ok, body[:some_values][:test]
      assert_equal :ok, body['some_values']['test']
    end
  end
end
