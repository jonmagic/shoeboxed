require "spec_helper"

describe Shoeboxed::Documents do
  let(:response) { double(:response) }
  let(:connection) {
    double(:connection, :upload => response,
                        :api_user_token => "foo",
                        :sbx_user_token => "bar")
  }
  subject { Shoeboxed::Documents.new(connection) }

  describe "#upload" do
    let(:document) { double(:document) }
    let(:options) { {} }

    it "instantiates Shoeboxed::Api::Upload with connection, document, and options" do
      upload_instance = double(:upload, :submit_request => true)

      Shoeboxed::Api::Upload.should_receive(:new).
        with(connection, document, options).
        and_return(upload_instance)

      subject.upload(document, options)
    end

    it "calls submit_request on instance" do
      upload_instance = double(:upload)
      upload_instance.should_receive(:submit_request)

      Shoeboxed::Api::Upload.stub(:new => upload_instance)

      subject.upload(document, options)
    end
  end

  describe "#status" do
    let(:attributes) {
      {
        "GetDocumentStatusCallResponse" => {
          "DocumentId"  => "1806912375",
          "DocumentType"=> "Receipt",
          "Status"      => "DONE",
          "guid"        => "abcd1234"
        }
      }
    }
    let(:response) {
      double(:response, :code => 200, :parsed_response => attributes)
    }

    before do
      subject.connection.stub(:post => response)
    end

    it "calls post on connection with query" do
      subject.connection.should_receive(:post).
        with({:xml=>"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Request xmlns=\"urn:sbx:apis:SbxBaseComponents\"><RequesterCredentials><ApiUserToken>foo</ApiUserToken><SbxUserToken>bar</SbxUserToken></RequesterCredentials><GetDocumentStatusCall><InserterId>abcd1234</InserterId></GetDocumentStatusCall></Request>"}).
        and_return(response)

      subject.status("abcd1234")
    end

    context "responds 200" do
      it "calls new on Status with document_status_hash_with_guid" do
        Shoeboxed::Status.should_receive(:new).
          with({"DocumentId"=>"1806912375", "DocumentType"=>"Receipt", "Status"=>"DONE", "guid"=>"abcd1234"})

        subject.status("abcd1234")
      end
    end

    context "responds 404" do
      let(:response) { double(:response, :code => 404) }

      it "returns nil" do
        expect(subject.status("1234")).to be_nil
      end
    end

    context "has_key GetDocumentStatusCallResponse" do
      it "returns Status instance" do
        expect(subject.status("abcd1234")).to be_instance_of(Shoeboxed::Status)
      end
    end

    context "has_key Error" do
      let(:attributes) {
        {
          "Error" => {
            "code"  => "1",
            "description" => "oh noes!"
          }
        }
      }

      it "returns nil" do
        expect(subject.status("1234")).to be_nil
      end
    end
  end

  describe "#connection" do
    it "returns connection passed in during instantiation" do
      expect(subject.connection).to eq(connection)
    end
  end
end
