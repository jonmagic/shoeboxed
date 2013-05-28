require "spec_helper"

describe Shoeboxed::Api::XmlRequest do
  describe "#parsed_response" do
    it "calls parsed_response on response" do
      response = double(:response)
      subject.stub(:response => response)

      response.should_receive(:parsed_response)

      subject.parsed_response
    end
  end

  describe "#response" do
    it "calls post on connection with query" do
      query = double(:query)
      subject.stub(:query => query)
      connection = double(:connection)
      subject.stub(:connection => connection)

      connection.should_receive(:post).with(query)

      subject.response
    end
  end

  describe "#query" do
    it "returns {:xml => xml}" do
      xml = double(:xml)
      subject.stub(:xml => xml)

      expect(subject.query).to eq({:xml => xml})
    end
  end
end
