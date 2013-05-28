require "spec_helper"

describe Shoeboxed::Api::Document do
  let(:response) { double(:response) }
  let(:connection) {
    double(:connection, :api_user_token => "foo",
                        :sbx_user_token => "bar",
                        :response => response)
  }
  let(:id) { "abcd1234" }
  let(:document_type) { "Receipt" }
  subject { described_class.new(connection, document_type, id) }

  describe "#submit_request" do
    let(:parsed_response) { {} }
    let(:response) {
      double(:response, :code => 200, :parsed_response => parsed_response)
    }

    before do
      subject.stub(:response => response)
    end

    context "missing 'GetReceiptInfoCallResponse'" do
      let(:parsed_response) { {:foo => "bar"} }

      it "raises 'UnrecognizedResponse' with message" do
        expect { subject.submit_request }.to \
          raise_error(Shoeboxed::UnrecognizedResponse, "Unrecognized response: {:foo=>\"bar\"}")
      end
    end

    context "in a perfect world" do
      let(:parsed_response) { {"GetReceiptInfoCallResponse" => {"Receipt" => {}}} }

      it "returns status hash with guid" do
        expect(subject.submit_request).to eq({})
      end
    end
  end

  describe "#xml" do
    it "returns valid xml" do
      fixture = File.read(fixture_path("GetReceiptInfoCallRequest"))

      expect(subject.xml).to eq(fixture)
    end
  end

  describe "#connection" do
    it "returns connection passed in at instantiation" do
      expect(subject.connection).to eq(connection)
    end
  end

  describe "#id" do
    it "returns id passed in at instantiation" do
      expect(subject.id).to eq(id)
    end
  end

  describe "#document_type" do
    it "returns document_type passed in at instantiation" do
      expect(subject.document_type).to eq(document_type)
    end
  end
end
