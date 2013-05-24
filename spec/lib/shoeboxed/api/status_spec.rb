require "spec_helper"

describe Shoeboxed::Api::Status do
  let(:response) { double(:response) }
  let(:connection) {
    double(:connection, :api_user_token => "foo",
                        :sbx_user_token => "bar",
                        :response => response)
  }
  let(:guid) { "abcd1234" }
  subject { described_class.new(connection, guid) }

  describe "#submit_request" do
    let(:parsed_response) { {} }
    let(:response) {
      double(:response, :code => 200, :parsed_response => parsed_response)
    }

    before do
      subject.stub(:response => response)
    end

    context "missing 'GetDocumentStatusCallResponse'" do
      let(:parsed_response) { {:foo => "bar"} }

      it "raises 'UnrecognizedResponse' with message" do
        expect { subject.submit_request }.to \
          raise_error(Shoeboxed::UnrecognizedResponse, "Unrecognized response: {:foo=>\"bar\"}")
      end
    end

    context "in a perfect world" do
      let(:parsed_response) { {"GetDocumentStatusCallResponse" => {}} }

      it "returns status hash with guid" do
        expect(subject.submit_request).to eq({"guid" => "abcd1234"})
      end
    end
  end

  describe "#response" do
    it "calls post on connection with query" do
      query = double(:query)
      subject.stub(:query => query)

      subject.connection.should_receive(:post).with(query)

      subject.response
    end
  end

  describe "#query" do
    it "returns {:xml => xml}" do
      xml = double(:xml)
      subject.stub(:xml => xml)

      expect(subject.query).to eq({:xml => xml})
    end
  end

  describe "#xml" do
    it "returns valid xml" do
      fixture = File.read(fixture_path("GetDocumentStatusCallRequest"))

      expect(subject.xml).to eq(fixture)
    end
  end

  describe "#connection" do
    it "returns connection passed in at instantiation" do
      expect(subject.connection).to eq(connection)
    end
  end

  describe "#guid" do
    it "returns connection passed in at instantiation" do
      expect(subject.guid).to eq(guid)
    end
  end
end
