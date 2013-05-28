require "spec_helper"

describe Shoeboxed::Receipt do
  let(:fixture) { File.read(fixture_path("GetReceiptInfoCallResponse")) }
  let(:attributes) { MultiXml.parse(fixture)["GetReceiptInfoCallResponse"]["Receipt"] }
  subject { described_class.new(attributes) }

  describe "#account_currency" do
    it "returns attributes['accountCurrency']" do
      expect(subject.account_currency).to eq(attributes["accountCurrency"])
    end
  end

  describe "#categories" do
    it "returns attributes['Categories']['Category']" do
      expect(subject.categories).to eq(attributes["Categories"]["Category"])
    end
  end

  describe "#conversion_rate" do
    it "returns attributes['conversionRate']" do
      expect(subject.conversion_rate).to eq(attributes["conversionRate"])
    end
  end

  describe "#converted_total" do
    it "returns attributes['convertedTotal']" do
      expect(subject.converted_total).to eq(attributes["convertedTotal"])
    end
  end

  describe "#date" do
    it "returns attributes['date']" do
      expect(subject.date).to eq(attributes["date"])
    end
  end

  describe "#document_currency" do
    it "returns attributes['documentCurrency']" do
      expect(subject.document_currency).to eq(attributes["documentCurrency"])
    end
  end

  describe "#document_total" do
    it "returns attributes['documentTotal']" do
      expect(subject.document_total).to eq(attributes["documentTotal"])
    end
  end

  describe "#id" do
    it "returns attributes['id']" do
      expect(subject.id).to eq(attributes["id"])
    end
  end

  describe "#store" do
    it "returns attributes['store']" do
      expect(subject.store).to eq(attributes["store"])
    end
  end
end
