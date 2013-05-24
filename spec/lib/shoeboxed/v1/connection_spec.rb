require "spec_helper"

describe Shoeboxed::V1::Connection do
  subject { Shoeboxed::V1::Connection.new("foo", "bar") }

  describe "#post" do
    it "calls post on class with ApiPath and query hash" do
      described_class.should_receive(:post).
        with(described_class::ApiPath, :query => {:foo => "bar"})

      subject.post({:foo => "bar"})
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
