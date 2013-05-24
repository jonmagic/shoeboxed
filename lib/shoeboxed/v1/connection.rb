require "httmultiparty"

class Shoeboxed
  module V1
    class Connection
      include HTTMultiParty

      # Public: Post query to Shoeboxed API endpoint.
      #
      # Returns a Response.
      def post(query)
        self.class.post(ApiPath, :query => query)
      end

      # Public: Post query to Shoeboxed upload endpoint.
      #
      # Returns a Response.
      def upload(query)
        self.class.post(UploadPath, :query => query)
      end

      # Public: Shoeboxed api_user_token for authenticated requests.
      attr_reader :api_user_token

      # Public: Shoeboxed sbx_user_token for authenticated requests.
      attr_reader :sbx_user_token

      # Internal: Called during object instantiation.
      #
      # api_user_token - String of api_user_token for authenticated requests.
      # sbx_user_token - String of sbx_user_token for authenticated requests.
      def initialize(api_user_token, sbx_user_token)
        @api_user_token = api_user_token
        @sbx_user_token = sbx_user_token
      end

      # Parse response body as xml.
      format :xml

      # Public: Root API url.
      ShoeboxedV1ApiUrl = "https://api.shoeboxed.com/v1/ws"

      # Internal: V1 API path.
      ApiPath = "/api.htm"

      # Internal: V1 Upload path.
      UploadPath = "/api-upload.htm"

      # Set Shoeboxed::V1::Connection.default_options[:base_uri].
      base_uri ShoeboxedV1ApiUrl
    end
  end
end
