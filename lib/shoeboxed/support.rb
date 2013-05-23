require "uri"

class Shoeboxed
  module Support
    # Public: Convert hash to query parameters for url.
    #
    # hash - Hash of keys and values to convert to query parameters.
    #
    # Returns a String.
    def self.hash_to_query_string(hash)
      hash.keys.inject("") do |query_string, key|
        query_string << "&" unless key == hash.keys.first
        query_string << "#{URI.encode(key.to_s)}=#{URI.encode(hash[key].to_s)}"
      end
    end
  end
end
