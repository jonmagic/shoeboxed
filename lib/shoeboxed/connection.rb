require "httmultiparty"

class Shoeboxed
  class Connection
    include HTTMultiParty

    # Public: Post query to Shoeboxed API endpoint. Handle non 200 response
    # codes and parsed response hash with 'Error' key.
    #
    # Returns a Response.
    def post(query)
      make_request_and_handle_errors do
        self.class.post(ApiPath, :query => query)
      end
    end

    # Public: Post query to Shoeboxed upload endpoint.
    #
    # Returns a Response.
    def upload(query)
      make_request_and_handle_errors do
        self.class.post(UploadPath, :query => query)
      end
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

    # Internal: Root API url.
    ShoeboxedV1ApiUrl = "https://api.shoeboxed.com/v1/ws"

    # Internal: V1 API path.
    ApiPath = "/api.htm"

    # Internal: V1 Upload path.
    UploadPath = "/api-upload.htm"

    # Set Shoeboxed::Connection.default_options[:base_uri].
    base_uri ShoeboxedV1ApiUrl

    def make_request_and_handle_errors(&block)
      response = block.call

      raise InternalServerError unless response.code == 200

      parsed_response = response.parsed_response
      if parsed_response.has_key?("Error")
        error = parsed_response["Error"]
        raise Error.new("Error code #{error["code"]}: #{error["description"]}")
      end

      response
    end
  end
end
