require "spec_helper"

describe Shoeboxed::Connection do
  let(:parsed_response) { {} }
  let(:response) {
    double(:response, :code => 200, :parsed_response => parsed_response)
  }
  subject { Shoeboxed::Connection.new("foo", "bar") }

  describe "#post" do
    before do
      described_class.stub(:post => response)
    end

    it "calls post on class with ApiPath and query hash" do
      described_class.should_receive(:post).
        with(described_class::ApiPath, :query => {:foo => "bar"})

      subject.post({:foo => "bar"})
    end

    context "non 200 response code" do
      it "raises 'Shoeboxed::InternalServerError'" do
        described_class.stub(:post => double(:response, :code => 404))

        expect { subject.post({}) }.to raise_error(Shoeboxed::InternalServerError)
      end
    end

    context "parsed_response has 'Error'" do
      let(:parsed_response) {
        {
          "Error" => {
            "code" => "1",
            "description" => "Bad credentials"
          }
        }
      }

      it "raises 'Shoeboxed::Error'" do
        expect { subject.post({}) }.to \
          raise_error(Shoeboxed::Error, "Error code 1: Bad credentials")
      end
    end

    context "in a perfect world" do
      it "returns parsed_response" do
        expect(subject.post({})).to eq(response)
      end
    end
  end

  describe "#upload" do
    it "calls post on class with UploadPath and query hash" do
      described_class.should_receive(:post).
        with(described_class::UploadPath, :query => {:foo => "bar"})

      subject.upload({:foo => "bar"})
    end
  end

  describe "#api_user_token" do
    it "returns api_user_token passed in during instantiation" do
      expect(subject.api_user_token).to eq("foo")
    end
  end

  describe "#sbx_user_token" do
    it "returns sbx_user_token passed in during instantiation" do
      expect(subject.sbx_user_token).to eq("bar")
    end
  end

  describe ".default_options[:format]" do
    it "returns :xml" do
      expect(described_class.default_options[:format]).to eq(:xml)
    end
  end

  describe "ShoeboxedV1ApiUrl" do
    it "returns '/api.htm'" do
      expect(described_class::ShoeboxedV1ApiUrl).to eq("https://api.shoeboxed.com/v1/ws")
    end
  end

  describe "ApiPath" do
    it "returns '/api.htm'" do
      expect(described_class::ApiPath).to eq("/api.htm")
    end
  end

  describe "UploadPath" do
    it "returns '/api.htm'" do
      expect(described_class::UploadPath).to eq("/api-upload.htm")
    end
  end

  describe ".default_options[:base_uri]" do
    it "returns 'https://api.shoeboxed.com/v1/ws'" do
      expect(described_class.default_options[:base_uri]).to eq("https://api.shoeboxed.com/v1/ws")
    end
  end
end
