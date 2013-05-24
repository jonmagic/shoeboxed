class Shoeboxed
  module Api
    class Status

      # Public: Submits request and returns response hash with 'guid' merged in.
      #
      # Returns a Hash.
      def submit_request
        unless parsed_response.has_key?("GetDocumentStatusCallResponse")
          raise UnrecognizedResponse.new("Unrecognized response: #{parsed_response.inspect}")
        end

        document_status_hash = parsed_response["GetDocumentStatusCallResponse"]
        document_status_hash.merge("guid" => guid)
      end

      # Public: Parsed response.
      #
      # Returns a Hash.
      def parsed_response
        response.parsed_response
      end

      # Public: Response from post request with query.
      #
      # Returns a HTTParty::Response.
      def response
        @response ||= connection.post(query)
      end

      # Internal: Query hash for request.
      #
      # Returns a Hash.
      def query
        {:xml => xml}
      end

      # Internal: Generated xml for request.
      #
      # Returns a String.
      def xml
        @xml ||= begin
          builder = ::Builder::XmlMarkup.new(:indent => 2)
          builder.instruct!(:xml, :version=>"1.0", :encoding=>"UTF-8")
          builder.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do
            builder.RequesterCredentials do
              builder.ApiUserToken(connection.api_user_token)
              builder.SbxUserToken(connection.sbx_user_token)
            end
            builder.GetDocumentStatusCall do
              builder.InserterId(guid)
            end
          end

          builder.target!
        end
      end

      # Internal: Called during object instantiation.
      #
      # connection - Shoeboxed::Connection instance.
      # guid       - String guid of document.
      def initialize(connection, guid)
        @connection = connection
        @guid = guid
      end

      # Internal: Shoeboxed::Connection for making requests.
      #
      # Returns a Shoeboxed::Connection.
      attr_reader :connection

      # Internal: String guid passed to Shoeboxed on upload to use for
      # referencing the document later.
      #
      # Returns a String.
      attr_reader :guid
    end
  end
end
