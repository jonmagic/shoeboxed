require "spec_helper"

describe Shoeboxed do
  describe ".authentication_url" do
    it "returns url for user to authenticate" do
      generated_url = Shoeboxed.authentication_url \
        :app_name => "Hoyt Accounting",
        :callback_url => "http://shoeboxed.herokuapp.com"

      expect(generated_url).to eq("https://api.shoeboxed.com/v1/ws/api.htm?appname=Hoyt%20Accounting&appurl=http://shoeboxed.herokuapp.com&SignIn=1&appparams=")
    end
  end
end
