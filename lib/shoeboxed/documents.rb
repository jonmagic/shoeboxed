require "builder"

class Shoeboxed
  class Documents
    # Public: Upload a document (pdf, png, jpg, or gif) for storage and
    # OCR processing. Specify the type (:receipt or :business_card) and
    # optionally specify a guid for referencing the document later.
    #
    # document - The document (File instance) to be uploaded.
    # options  - Hash of options.
    #
    # Returns a TrueClass or FalseClass.
    def upload(document, options=nil)
      options = options || {}
      api_upload = Api::Upload.new(connection, document, options)
      api_upload.submit_request
    end

    # Public: Look up the status of a document by guid.
    #
    # guid - The guid sent as inserterId when the document was uploaded.
    #
    # Returns a Shoeboxed::Status.
    def status(guid)
      api_status = Api::Status.new(connection, guid)
      response_hash_with_guid = api_status.submit_request
      Status.new(response_hash_with_guid)
    end

    # Internal: Called during object instantiation. Takes a connection.
    #
    # connection - Shoeboxed::Connection instance.
    def initialize(connection)
      @connection = connection
    end

    # Internal: Connection for making api calls.
    #
    # Returns a Shoeboxed::Connection.
    attr_reader :connection
  end
end
