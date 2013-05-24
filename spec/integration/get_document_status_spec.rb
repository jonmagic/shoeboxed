require "spec_helper"

describe "Getting the status of a document" do
  subject(:shoeboxed) {
    Shoeboxed.new(:api_user_token => "foo", :sbx_user_token => "bar")
  }
  let(:upload_url) { "https://api.shoeboxed.com/v1/ws/api.htm" }
  subject(:status) { shoeboxed.status("abcd1234") }

  context "Document is processing" do
    before do
      body = File.read(fixture_path("GetDocumentStatusCallProcessingResponse"))

      stub_request(:post, upload_url).
        to_return(:status => 200, :body => body)
    end

    describe "Status#processing?" do
      it "returns true" do
        expect(status.processing?).to be_true
      end
    end

    describe "Status#done?" do
      it "returns false" do
        expect(status.done?).to be_false
      end
    end

    describe "Status#status" do
      it "returns :processing" do
        expect(status.status).to eq(:processing)
      end
    end

    describe "Status#guid" do
      it "returns guid" do
        expect(status.guid).to eq("abcd1234")
      end
    end

    describe "Status#document_id" do
      it "returns nil" do
        expect(status.document_id).to be_nil
      end
    end

    describe "Status#document_type" do
      it "returns nil" do
        expect(status.document_type).to be_nil
      end
    end
  end

  context "Document has finished processing" do
    before do
      body = File.read(fixture_path("GetDocumentStatusCallDoneResponse"))

      stub_request(:post, upload_url).
        to_return(:status => 200, :body => body)
    end

    describe "Status#processing?" do
      it "returns false" do
        expect(status.processing?).to be_false
      end
    end

    describe "Status#done?" do
      it "returns true" do
        expect(status.done?).to be_true
      end
    end

    describe "Status#status" do
      it "returns :done" do
        expect(status.status).to eq(:done)
      end
    end

    describe "Status#guid" do
      it "returns guid" do
        expect(status.guid).to eq("abcd1234")
      end
    end

    describe "Status#document_id" do
      it "returns document id" do
        expect(status.document_id).to eq("8374927320")
      end
    end

    describe "Status#document_type" do
      it "returns document type" do
        expect(status.document_type).to eq(:receipt)
      end
    end
  end
end
