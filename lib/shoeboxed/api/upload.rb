class Shoeboxed
  module Api
    class Upload
      # Public: Submit upload request.
      #
      # Returns a TrueClass or FalseClass.
      def submit_request
        return false unless response.code == 200
        return false unless response.parsed_response.has_key?("UploadImagesResponse")
        true
      end

      # Public: Uploads document and returns response.
      #
      # Returns an HTTParty::Response.
      def response
        @response ||= connection.upload(query)
      end

      # Internal: Called during object instantiation.
      #
      # connection - Shoeboxed::Connection instance.
      # document   - Document (File instance) to upload.
      # options    - Hash of options.
      def initialize(connection, document, options)
        @connection  = connection
        @document    = document
        @type        = options.fetch(:type, :receipt)
        @guid        = options.fetch(:guid, nil)
        @note        = options.fetch(:note, nil)
        @category_id = options.fetch(:category_id, nil)
        @export      = options.fetch(:export, nil)
      end

      # Internal: Builds a query hash for posting to the API.
      #
      # Returns a Hash.
      def query
        query = {}

        # Set required parameters.
        query["images"]    = document
        query["imageType"] = DocumentTypes[type]

        # Set optional parameters.
        query["inserterId"] = guid        if guid
        query["note"]       = note        if note
        query["categories"] = category_id if category_id

        # Set authentication parameters.
        query["apiUserToken"] = connection.api_user_token
        query["sbxUserToken"] = connection.sbx_user_token

        # Return query.
        query
      end

      # Internal: Shoeboxed::Connection for making requests.
      #
      # Returns a Shoeboxed::Connection.
      attr_reader :connection

      # Internal: Document (File instance) to upload.
      #
      # Returns a File.
      attr_reader :document

      # Internal: Document type, :receipt or :business_card. Defaults to
      # :receipt on object instantiation.
      #
      # Returns a Symbol.
      attr_reader :type

      # Internal: Optional guid passed to Shoeboxed on upload to use for
      # referencing the document later.
      #
      # Returns a String.
      attr_reader :guid

      # Internal: Optional note to attach to document upload.
      #
      # Returns a String.
      attr_reader :note

      # Internal: Optional Shoeboxed category id to categorize document on
      # upload.
      #
      # Returns a String.
      attr_reader :category_id

      # Internal: Map document type symbols to Shoeboxed document types
      # for upload.
      DocumentTypes = {
        :business_card => "business-card",
        :receipt       => "receipt"
      }
    end
  end
end
