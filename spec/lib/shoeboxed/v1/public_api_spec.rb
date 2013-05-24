require "spec_helper"

describe Shoeboxed::V1::PublicApi do
  let(:response) { double(:response, :code => 200, :has_key? => true) }
  let(:connection) {
    double(:connection, :upload => response,
                        :api_user_token => "foo",
                        :sbx_user_token => "bar")
  }
  subject { Shoeboxed::V1::PublicApi.new(connection) }

  describe "#upload" do
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

  describe "DocumentTypes" do
    it "returns Shoeboxed types" do
      expect(Shoeboxed::V1::PublicApi::DocumentTypes[:receipt]).to eq("receipt")
      expect(Shoeboxed::V1::PublicApi::DocumentTypes[:business_card]).to eq("business-card")
    end
  end

  describe "#connection" do
    it "returns connection passed in during instantiation" do
      expect(subject.connection).to eq(connection)
    end
  end
end
