require "spec_helper"

describe Shoeboxed do
  subject { Shoeboxed.new(:api_user_token => "foo", :sbx_user_token => "bar") }

  describe ".authentication_url" do
    it "returns url for user to authenticate" do
      generated_url = described_class.authentication_url \
        :app_name => "Hoyt Accounting",
        :callback_url => "http://shoeboxed.herokuapp.com"

      expect(generated_url).to match(/#{Regexp.escape("https://api.shoeboxed.com/v1/ws/api.htm?")}/)
      expect(generated_url).to match(/#{Regexp.escape("appname=Hoyt+Accounting")}/)
      expect(generated_url).to match(/#{Regexp.escape("appurl=http%3A%2F%2Fshoeboxed.herokuapp.com")}/)
      expect(generated_url).to match(/#{Regexp.escape("SignIn=1")}/)
      expect(generated_url).to match(/#{Regexp.escape("appparams=")}/)
    end
  end

  describe "#upload" do
    it "delegates to documents" do
      subject.documents.should_receive(:upload)
      subject.upload
    end
  end

  describe "#documents" do
    it "returns instance of Shoeboxed::Documents" do
      expect(subject.documents).to be_instance_of(Shoeboxed::Documents)
    end
  end

  describe "#connection" do
    it "returns instance of Shoeboxed::Connection" do
      expect(subject.connection).to be_instance_of(Shoeboxed::Connection)
    end
  end
end
