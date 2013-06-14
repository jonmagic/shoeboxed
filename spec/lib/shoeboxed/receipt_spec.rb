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

    it "returns nil if 'Categories' is missing" do
      subject.attributes.delete("Categories")
      expect(subject.categories).to be_nil
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

  describe "#issuer" do
    it "returns attributes['PaymentType']['issuer']" do
      expect(subject.issuer).to eq(attributes["PaymentType"]["issuer"])
    end

    it "returns nil if 'PaymentType' is missing" do
      subject.attributes.delete("PaymentType")
      expect(subject.issuer).to be_nil
    end
  end

  describe "#last_four_digits" do
    it "returns attributes['PaymentType']['lastFourDigits']" do
      expect(subject.last_four_digits).to \
        eq(attributes["PaymentType"]["lastFourDigits"])
    end

    it "returns nil if 'PaymentType' is missing" do
      subject.attributes.delete("PaymentType")
      expect(subject.last_four_digits).to be_nil
    end
  end

  describe "#payment_type" do
    it "returns attributes['PaymentType']['type']" do
      expect(subject.payment_type).to eq(attributes["PaymentType"]["type"])
    end

    it "returns nil if 'PaymentType' is missing" do
      subject.attributes.delete("PaymentType")
      expect(subject.payment_type).to be_nil
    end
  end

  describe "#sell_date" do
    it "returns attributes['selldate']" do
      expect(subject.sell_date).to eq(attributes["selldate"])
    end
  end

  describe "#store" do
    it "returns attributes['store']" do
      expect(subject.store).to eq(attributes["store"])
    end
  end
end
