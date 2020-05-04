require 'test_helper'

describe VertexClient::Resource::Base do
  class VertexClient::Resource::MyTest < VertexClient::Resource::Base
    ENDPOINT = 'MyEndPoint'.freeze
  end
  class VertexClient::Payload::MyTest < VertexClient::Payload::Base
    def validate!
    end

    def body
      @params
    end
  end
  class VertexClient::Response::MyTest  < VertexClient::Response::Base; end;

  let(:resource) { VertexClient::Resource::MyTest.new({ test: :ok })}
  let(:connection) { resource.send(:connection) }
  let(:payload) { resource.instance_variable_get(:@payload) }

  describe 'initialize' do
    it 'sets @payload with a new instance of payload_type' do
      assert_kind_of VertexClient::Payload::MyTest, payload
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

    describe 'when a soap fault is raised' do
      let(:nori) { Nori.new(:strip_namespaces => true, :convert_tags_to => lambda { |tag| tag.snakecase.to_sym }) }
      let(:address_fault) { fault_message(<<-ERROR) }
        No tax areas were found during the lookup. The address fields are inconsistent for the specified asOfDate. (Street Information=1-252 AR / B- BTRY, Street Information 2=null, Postal Code=UNIT, City=APOAE, Sub Division=null, Main Division=09877-1368, Country=USA, As Of Date=20200419) Failed to cleanse address. (fault code=E412, fault code text=Primary name not found in directory.)
      ERROR
      let(:fault) { fault_message("The request cannot be processed") }
      let(:address_soap_fault) { Savon::SOAPFault.new(HTTPI::Response.new(500, {}, address_fault), nori) }
      let(:soap_fault) { Savon::SOAPFault.new(HTTPI::Response.new(500, {}, fault), nori) }

      it 'maps to a validation exception for address errors' do
        connection.stubs(:request).raises(address_soap_fault)
        assert_raises(VertexClient::ValidationError) { resource.result }
      end

      it 'raises SOAPFault for non validation errors' do
        connection.stubs(:request).raises(soap_fault)
        assert_raises(Savon::SOAPFault) { resource.result }
      end

      def fault_message(fault_string)
        <<-STRING
          <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
             <soap:Body>
                <soap:Fault>
                   <faultcode>soapenv:Client</faultcode>
                   <faultstring>#{fault_string}</faultstring>
                </soap:Fault>
             </soap:Body>
          </soap:Envelope>
        STRING
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
