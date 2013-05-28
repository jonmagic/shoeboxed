class Shoeboxed
  module Api
    class Status < XmlRequest
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

      # Internal: Generated xml for request.
      #
      # Returns a String.
      def xml
        @xml ||= begin
          builder = ::Builder::XmlMarkup.new(:indent => 4)

          authed_xml_as_string(builder) do
            builder.GetDocumentStatusCall do
              builder.InserterId(guid)
            end
          end
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
