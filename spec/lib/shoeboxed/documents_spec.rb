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
    let(:guid) { double(:guid) }
    let(:response_hash_with_guid) { double(:response_hash_with_guid) }

    before do
      Shoeboxed::Status.stub(:new)
    end

    it "instantiates Shoeboxed::Api::Status with connection and guid" do
      status_instance = double(:status,
                               :submit_request => true,
                               :response_hash_with_guid => response_hash_with_guid)

      Shoeboxed::Api::Status.should_receive(:new).
        with(connection, guid).
        and_return(status_instance)

      subject.status(guid)
    end

    it "calls submit_request on instance" do
      status_instance = double(:status, :response_hash_with_guid => response_hash_with_guid)
      status_instance.should_receive(:submit_request)

      Shoeboxed::Api::Status.stub(:new => status_instance)

      subject.status(guid)
    end

    it "creates new Shoeboxed::Status with response_hash_with_guid" do
      status_instance = double(:status, :submit_request => response_hash_with_guid)
      Shoeboxed::Status.should_receive(:new).with(response_hash_with_guid)

      Shoeboxed::Api::Status.stub(:new => status_instance)

      subject.status(guid)
    end
  end

  describe "#find_by_guid" do
    let(:status) {
      double(:status, :document_type_class_name => "Receipt", :document_id => "abcd1234")
    }
    before do
      subject.stub(:status => status)
      subject.stub(:find_by_type_and_id => nil)
    end

    it "calls status with guid" do
      subject.should_receive(:status).with("abcd1234")
      subject.find_by_guid("abcd1234")
    end

    it "calls find_by_type_and_id with guid" do
      subject.should_receive(:find_by_type_and_id).
        with(status.document_type_class_name, status.document_id)
      subject.find_by_guid("abcd1234")
    end

    context "document not finished processing" do
      let(:status) {
        double(:status, :document_type_class_name => nil, :document_id => nil)
      }

      it "returns nil" do
        expect(subject.find_by_guid("abcd1234")).to be_nil
      end
    end
  end

  describe "#find_by_type_and_id" do
    let(:attributes) { double(:attributes) }
    let(:document) { double(:document, :submit_request => attributes) }

    before do
      Shoeboxed::Api::Document.stub(:new => document)
    end

    it "gets constant from document type class name" do
      Shoeboxed.should_receive(:const_get).
        with("Receipt").
        and_return(Shoeboxed::Receipt)
      subject.find_by_type_and_id("Receipt", "abcd1234")
    end

    it "creates new instance of Api::Document with connection, type, and id" do
      Shoeboxed::Api::Document.should_receive(:new).
        with(connection, "Receipt", "abcd1234")
      subject.find_by_type_and_id("Receipt", "abcd1234")
    end

    it "calls submit_reqeuest on the document" do
      document.should_receive(:submit_request)
      subject.find_by_type_and_id("Receipt", "abcd1234")
    end

    it "calls new on constant with attributes" do
      Shoeboxed::Receipt.should_receive(:new).with(attributes)
      subject.find_by_type_and_id("Receipt", "abcd1234")
    end
  end

  describe "#connection" do
    it "returns connection passed in during instantiation" do
      expect(subject.connection).to eq(connection)
    end
  end
end
