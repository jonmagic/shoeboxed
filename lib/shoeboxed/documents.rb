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

    # Public: Find document by guid.
    #
    # guid - The guid sent as inserterId when the document was uploaded.
    #
    # Returns a BusinessCard, OtherDocument, or Receipt.
    def find_by_guid(guid)
      status = status(guid)
      return unless status.document_type_class_name && status.document_id
      find_by_type_and_id(status.document_type_class_name, status.document_id)
    end

    # Public: Find document by Shoeboxed id.
    #
    # type - Document type as a String. Possible values are BusinessCard,
    #        OtherDocument, or Receipt.
    # id   - Shoeboxed id as a String.
    #
    # Returns a BusinessCard, OtherDocument, or Receipt.
    def find_by_type_and_id(type, id)
      constant = Shoeboxed.const_get(type)
      document = Api::Document.new(connection, type, id)
      attributes = document.submit_request
      constant.new(attributes)
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
