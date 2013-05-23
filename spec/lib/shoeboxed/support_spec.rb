require "spec_helper"

describe Shoeboxed::Support do
  describe ".hash_to_query_string" do
    it "returns has as query string" do
      hash = {:foo => "This & That", :a => 1, :dev => "Jon Hoyt", :yo => nil}
      query_string = Shoeboxed::Support.hash_to_query_string(hash)
      expect(query_string).to eq("foo=This%20&%20That&a=1&dev=Jon%20Hoyt&yo=")
    end
  end
end
