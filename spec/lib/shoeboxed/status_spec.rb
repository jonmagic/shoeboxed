require "spec_helper"

describe Shoeboxed::Status do
  let(:attributes) {
    {
      "DocumentId"  => "1806912375",
      "DocumentType"=> "Receipt",
      "Status"      => "DONE",
      "guid"        => "abcd1234"
    }
  }
  subject { described_class.new(attributes) }

  describe "#done?" do
    context ":processing" do
      it "returns false" do
        subject.stub(:status => :processing)
        expect(subject.done?).to be_false
      end
    end

    context ":done" do
      it "returns true" do
        subject.stub(:status => :done)
        expect(subject.done?).to be_true
      end
    end
  end

  describe "#processing?" do
    context ":processing" do
      it "returns true" do
        subject.stub(:status => :processing)
        expect(subject.processing?).to be_true
      end
    end

    context ":done" do
      it "returns false" do
        subject.stub(:status => :done)
        expect(subject.processing?).to be_false
      end
    end
  end

  describe "#status" do
    it "returns status as symbol" do
      expect(subject.status).to eq(:done)
    end
  end

  describe "#guid" do
    it "returns guid" do
      expect(subject.guid).to eq("abcd1234")
    end
  end

  describe "#document_id" do
    it "returns document_id" do
      expect(subject.document_id).to eq("1806912375")
    end
  end

  describe "#document_type" do
    it "returns document_type as symbol" do
      expect(subject.document_type).to eq(:receipt)
    end
  end

  describe "#document_type_class_name" do
    context "Receipt" do
      let(:attributes) {
        {
          "DocumentId"  => "1806912375",
          "DocumentType"=> "Receipt",
          "Status"      => "DONE",
          "guid"        => "abcd1234"
        }
      }

      it "returns Receipt" do
        expect(subject.document_type_class_name).to eq("Receipt")
      end
    end

    context "BusinessCard" do
      let(:attributes) {
        {
          "DocumentId"  => "1806912375",
          "DocumentType"=> "BusinessCard",
          "Status"      => "DONE",
          "guid"        => "abcd1234"
        }
      }

      it "returns BusinessCard" do
        expect(subject.document_type_class_name).to eq("BusinessCard")
      end
    end

    context "OtherDocument" do
      let(:attributes) {
        {
          "DocumentId"  => "1806912375",
          "DocumentType"=> "OtherDocument",
          "Status"      => "DONE",
          "guid"        => "abcd1234"
        }
      }

      it "returns OtherDocument" do
        expect(subject.document_type_class_name).to eq("OtherDocument")
      end
    end
  end

  describe "States" do
    it "returns translated types" do
      expect(described_class::States["PROCESSING"]).to eq(:processing)
      expect(described_class::States["DONE"]).to eq(:done)
    end
  end

  describe "DocumentTypes" do
    it "returns translated types" do
      expect(described_class::DocumentTypes["Receipt"]).to eq(:receipt)
      expect(described_class::DocumentTypes["BusinessCard"]).to eq(:business_card)
      expect(described_class::DocumentTypes["OtherDocument"]).to eq(:other_document)
    end
  end
end
