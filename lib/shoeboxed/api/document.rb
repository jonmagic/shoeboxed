class Shoeboxed
  module Api
    class Document < XmlRequest
      # Public: Make document info request and return self.
      #
      # Returns a Hash.
      def submit_request
        unless parsed_response.has_key?("Get#{document_type}InfoCallResponse")
          raise UnrecognizedResponse.new("Unrecognized response: #{parsed_response.inspect}")
        end

        parsed_response["Get#{document_type}InfoCallResponse"][document_type]
      end

      # Internal: Generated xml for request.
      #
      # Returns a String.
      def xml
        @xml ||= begin
          builder = ::Builder::XmlMarkup.new(:indent => 4)

          authed_xml_as_string(builder) do
            builder.GetReceiptInfoCall do
              builder.ReceiptFilter do
                builder.ReceiptId(id)
              end
            end
          end
        end
      end

      # Internal: Called during object instantiation.
      #
      # connection - Shoeboxed::Connection instance.
      # id         - String id of document.
      # document_type - Camel cased document type class name as String.
      def initialize(connection, document_type, id)
        @connection = connection
        @document_type = document_type
        @id = id
      end

      # Internal: Shoeboxed::Connection for making requests.
      #
      # Returns a Shoeboxed::Connection.
      attr_reader :connection

      # Internal: String id assigned by Shoeboxed.
      #
      # Returns a String.
      attr_reader :id

      # Internal: Camel cased document type class name as a String.
      #
      # Returns a String.
      attr_reader :document_type
    end
  end
end
