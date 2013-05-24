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
      xml = ::Builder::XmlMarkup.new
      xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do
        xml.RequesterCredentials do
          xml.ApiUserToken(connection.api_user_token)
          xml.SbxUserToken(connection.sbx_user_token)
        end
        xml.GetDocumentStatusCall do
          xml.InserterId(guid)
        end
      end

      query = {:xml => xml.target!}
      response = connection.post(query)
      return unless response.code == 200

      parsed_response = response.parsed_response
      return unless parsed_response.has_key?("GetDocumentStatusCallResponse")

      document_status_hash = parsed_response["GetDocumentStatusCallResponse"]
      document_status_hash_with_guid = document_status_hash.merge("guid" => guid)
      Status.new(document_status_hash_with_guid)
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
