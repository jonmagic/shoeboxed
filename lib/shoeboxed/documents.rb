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
      options     = options || {}
      type        = options.fetch(:type, :receipt)
      guid        = options.fetch(:guid, nil)
      note        = options.fetch(:note, nil)
      category_id = options.fetch(:category_id, nil)
      export      = options.fetch(:export, nil)
      query = {}

      # Required parameters.
      query["images"]     = document
      query["imageType"]  = Types[type]

      # Optional parameters.
      query["inserterId"] = guid        if guid
      query["note"]       = note        if note
      query["categories"] = category_id if category_id
      query["exportAfterProcessing"] = export if export

      # Authentication parameters.
      query["apiUserToken"] = connection.api_user_token
      query["sbxUserToken"] = connection.sbx_user_token

      response = connection.upload(query)
      return false unless response.code == 200
      return false unless response.has_key?("UploadImagesResponse")
      true
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

    # Internal: Map document type symbols to strings the Shoeboxed V1 API
    # understands.
    Types = {
      :business_card => "business-card",
      :receipt       => "receipt"
    }

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
