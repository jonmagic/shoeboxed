require "spec_helper"

describe Shoeboxed do
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
end
