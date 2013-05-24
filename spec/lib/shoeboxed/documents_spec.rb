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
    let(:response) { double(:response, :code => 200, :has_key? => true) }
    let(:document) { File.new(fixture_path("receipt", "jpg")) }
    let(:base_query) { {"apiUserToken" => "foo", "sbxUserToken" => "bar"} }

    context "without options hash" do
      it "calls connection.upload with query and returns true" do
        desired_query = base_query.merge({
          "images"    => document,
          "imageType" => "receipt"
        })

        subject.connection.
          should_receive(:upload).
          with(desired_query).
          and_return(response)

        expect(subject.upload(document)).to be_true
      end
    end

    context "with options hash containing type" do
      it "calls connection.upload with query and returns true" do
        desired_query = base_query.merge({
          "images"     => document,
          "imageType"  => "business-card"
        })

        subject.connection.
          should_receive(:upload).
          with(desired_query).
          and_return(response)

        expect(subject.upload(document, {:type => :business_card})).to be_true
      end
    end

    context "with options hash containing guid" do
      it "calls connection.upload with query and returns true" do
        desired_query = base_query.merge({
          "images"     => document,
          "imageType"  => "receipt",
          "inserterId" => "abcd1234"
        })

        subject.connection.
          should_receive(:upload).
          with(desired_query).
          and_return(response)

        expect(subject.upload(document, {:guid => "abcd1234"})).to be_true
      end
    end

    context "non 200 code" do
      let(:response) { double(:response, :code => 404) }

      it "returns false" do
        expect(subject.upload(document)).to be_false
      end
    end

    context "not an UploadImagesResponse" do
      let(:response) { double(:response, :code => 200, :has_key? => false) }

      it "returns false" do
        expect(subject.upload(document)).to be_false
      end
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

  describe "Types" do
    it "returns Shoeboxed types" do
      expect(described_class::Types[:receipt]).to eq("receipt")
      expect(described_class::Types[:business_card]).to eq("business-card")
    end
  end

  describe "#connection" do
    it "returns connection passed in during instantiation" do
      expect(subject.connection).to eq(connection)
    end
  end
end
