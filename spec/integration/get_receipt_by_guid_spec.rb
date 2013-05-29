require "spec_helper"

describe "find Receipt by guid" do
  subject(:shoeboxed) {
    Shoeboxed.new(:api_user_token => "foo", :sbx_user_token => "bar")
  }
  let(:guid) { "abcd1234" }
  subject { shoeboxed.find_by_guid(guid) }

  context "Receipt is found" do
    before do
      stub_request(:post, "https://api.shoeboxed.com/v1/ws/api.htm").
        with(:body => "xml=%3C%3Fxml%20version%3D%221.0%22%20encoding%3D%22UTF-8%22%3F%3E%0A%3CRequest%20xmlns%3D%22urn%3Asbx%3Aapis%3ASbxBaseComponents%22%3E%0A%20%20%20%20%3CRequesterCredentials%3E%0A%20%20%20%20%20%20%20%20%3CApiUserToken%3Efoo%3C%2FApiUserToken%3E%0A%20%20%20%20%20%20%20%20%3CSbxUserToken%3Ebar%3C%2FSbxUserToken%3E%0A%20%20%20%20%3C%2FRequesterCredentials%3E%0A%20%20%20%20%3CGetDocumentStatusCall%3E%0A%20%20%20%20%20%20%20%20%3CInserterId%3Eabcd1234%3C%2FInserterId%3E%0A%20%20%20%20%3C%2FGetDocumentStatusCall%3E%0A%3C%2FRequest%3E%0A").
        to_return(:body => File.read(fixture_path("GetDocumentStatusCallDoneResponse")))
      stub_request(:post, "https://api.shoeboxed.com/v1/ws/api.htm").
        with(:body => "xml=%3C%3Fxml%20version%3D%221.0%22%20encoding%3D%22UTF-8%22%3F%3E%0A%3CRequest%20xmlns%3D%22urn%3Asbx%3Aapis%3ASbxBaseComponents%22%3E%0A%20%20%20%20%3CRequesterCredentials%3E%0A%20%20%20%20%20%20%20%20%3CApiUserToken%3Efoo%3C%2FApiUserToken%3E%0A%20%20%20%20%20%20%20%20%3CSbxUserToken%3Ebar%3C%2FSbxUserToken%3E%0A%20%20%20%20%3C%2FRequesterCredentials%3E%0A%20%20%20%20%3CGetReceiptInfoCall%3E%0A%20%20%20%20%20%20%20%20%3CReceiptFilter%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3CReceiptId%3E8374927320%3C%2FReceiptId%3E%0A%20%20%20%20%20%20%20%20%3C%2FReceiptFilter%3E%0A%20%20%20%20%3C%2FGetReceiptInfoCall%3E%0A%3C%2FRequest%3E%0A").
        to_return(:body => File.read(fixture_path("GetReceiptInfoCallResponse")))
    end

    it "returns Shoeboxed::Receipt" do
      expect(subject).to be_instance_of(Shoeboxed::Receipt)
      expect(subject.converted_total).to eq("281.44")
      expect(subject.date).to eq("05/22/2013")
    end
  end
end
