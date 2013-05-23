require "spec_helper"

describe Shoeboxed do
  let(:shoeboxed) {
    Shoeboxed.new(:api_user_token => "foo", :sbx_user_token => "bar")
  }

  describe ".authentication_url" do
    it "returns url for user to authenticate" do
      generated_url = Shoeboxed.authentication_url \
        :app_name => "Hoyt Accounting",
        :callback_url => "http://shoeboxed.herokuapp.com"

      expect(generated_url).to match(/#{Regexp.escape("https://api.shoeboxed.com/v1/ws/api.htm?")}/)
      expect(generated_url).to match(/#{Regexp.escape("appname=Hoyt+Accounting")}/)
      expect(generated_url).to match(/#{Regexp.escape("appurl=http%3A%2F%2Fshoeboxed.herokuapp.com")}/)
      expect(generated_url).to match(/#{Regexp.escape("SignIn=1")}/)
      expect(generated_url).to match(/#{Regexp.escape("appparams=")}/)
    end
  end

  describe "#api_user_token" do
    it "returns value sent in options on instantiation." do
      expect(shoeboxed.api_user_token).to eq("foo")
    end

    it "raises error if :api_user_token is not present" do
      expect {
        Shoeboxed.new(:sbx_user_token => "bar")
      }.to raise_error(KeyError)
    end
  end

  describe "#sbx_user_token" do
    it "returns value sent in options on instantiation." do
      expect(shoeboxed.sbx_user_token).to eq("bar")
    end

    it "raises error if :sbx_user_token is not present" do
      expect {
        Shoeboxed.new(:api_user_token => "foo")
      }.to raise_error(KeyError)
    end
  end
end
