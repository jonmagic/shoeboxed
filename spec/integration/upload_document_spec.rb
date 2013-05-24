require "spec_helper"

describe "Uploading a document" do
  subject(:shoeboxed) {
    Shoeboxed.new(:api_user_token => "foo", :sbx_user_token => "bar")
  }
  let(:document) { File.new(fixture_path("receipt", "jpg")) }
  let(:upload_url) { "https://api.shoeboxed.com/v1/ws/api-upload.htm" }

  context "success" do
    it "responds true" do
      body = File.read(fixture_path("UploadSuccessResponse"))

      stub_request(:post, upload_url).
        to_return(:status => 200, :body => body)

      expect(shoeboxed.upload(document)).to be_true
    end
  end

  context "needs attention" do
    it "responds true" do
      body = File.read(fixture_path("UploadSuccessNeedsAttentionResponse"))

      stub_request(:post, upload_url).
        to_return(:status => 200, :body => body)

      expect(shoeboxed.upload(document)).to be_true
    end
  end

  context "bad credentials" do
    it "responds false" do
      body = File.read(fixture_path("UploadFailureBadCredentialsResponse"))

      stub_request(:post, upload_url).
        to_return(:status => 200, :body => body)

      expect { shoeboxed.upload(document) }.to \
        raise_error(Shoeboxed::Error, "Error code 1: Bad credentials")
    end
  end

  context "internal error" do
    it "responds false" do
      body = File.read(fixture_path("UploadFailureInternalErrorResponse"))

      stub_request(:post, upload_url).
        to_return(:status => 200, :body => body)

      expect { shoeboxed.upload(document) }.to \
        raise_error(Shoeboxed::Error,
                    "Error code 5: An internal error has occurred.")
    end
  end

  context "responds 404" do
    it "responds false" do
      stub_request(:post, upload_url).
        to_return(:status => 404)

      expect { shoeboxed.upload(document) }.to \
        raise_error(Shoeboxed::InternalServerError)
    end
  end
end
