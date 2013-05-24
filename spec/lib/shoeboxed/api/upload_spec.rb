require "spec_helper"

describe Shoeboxed::Api::Upload do
  let(:response) { double(:response) }
  let(:connection) {
    double(:connection, :upload => response,
                        :api_user_token => "foo",
                        :sbx_user_token => "bar")
  }
  let(:document) { double(:document) }
  let(:options) {
    {
      :guid => "1234567890",
      :note => "Who are you?",
      :category_id => "1"
    }
  }
  subject { Shoeboxed::Api::Upload.new(connection, document, options) }

  describe "#submit_request" do
    before do
      subject.stub(:response => response)
    end

    context "response.code does not equal 200" do
      let(:response) {
        double(:response, :code => 404,
                          :parsed_response => {"UploadImagesResponse" => {}})
      }

      it "returns false" do
        expect(subject.submit_request).to be_false
      end
    end

    context "parsed_response does not have key 'UploadImagesResponse'" do
      let(:response) {
        double(:response, :code => 200,
                          :parsed_response => {"Error" => {}})
      }

      it "returns false" do
        expect(subject.submit_request).to be_false
      end
    end

    context "code is 200 and parsed_response has ''" do
      let(:response) {
        double(:response, :code => 200,
                          :parsed_response => {"UploadImagesResponse" => {}})
      }

      it "returns true" do
        expect(subject.submit_request).to be_true
      end
    end
  end

  describe "#response" do
    it "calls upload on connection with query" do
      subject.connection.should_receive(:upload).with(subject.query)

      subject.response
    end
  end

  describe "#query" do
    it "sets 'images' to document" do
      expect(subject.query["images"]).to eq(document)
    end

    it "sets 'imageType' to translated type" do
      expect(subject.query["imageType"]).to eq("receipt")
    end

    it "sets 'inserterId' to guid" do
      expect(subject.query["inserterId"]).to eq("1234567890")
    end

    it "sets 'note' to note" do
      expect(subject.query["note"]).to eq("Who are you?")
    end

    it "sets 'categories' to category_id" do
      expect(subject.query["categories"]).to eq("1")
    end

    it "sets 'apiUserToken' to connection.api_user_token" do
      expect(subject.query["apiUserToken"]).to eq("foo")
    end

    it "sets 'sbxUserToken' to connection.sbx_user_token" do
      expect(subject.query["sbxUserToken"]).to eq("bar")
    end
  end

  describe "#connection" do
    it "returns connection passed in at instantiation" do
      expect(subject.connection).to eq(connection)
    end
  end

  describe "#document" do
    it "returns document passed in at instantiation" do
      expect(subject.document).to eq(document)
    end
  end

  describe "#type" do
    context "type not passed in" do
      it "returns default type :receipt" do
        expect(subject.type).to eq(:receipt)
      end
    end

    context "type passed in" do
      let(:options) { {:type => :business_card} }

      it "returns type passed in options during instantiation" do
        expect(subject.type).to eq(:business_card)
      end
    end
  end

  describe "#guid" do
    it "returns guid passed in options during instantiation" do
      expect(subject.guid).to eq("1234567890")
    end
  end

  describe "#note" do
    it "returns note passed in options during instantiation" do
      expect(subject.note).to eq("Who are you?")
    end
  end

  describe "#category_id" do
    let(:options) { {:category_id => "1"} }

    it "returns category_id passed in options during instantiation" do
      expect(subject.category_id).to eq("1")
    end
  end

  describe "Types" do
    it "returns Shoeboxed types" do
      expect(described_class::DocumentTypes[:receipt]).to eq("receipt")
      expect(described_class::DocumentTypes[:business_card]).to eq("business-card")
    end
  end
end
