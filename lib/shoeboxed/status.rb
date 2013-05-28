class Shoeboxed
  class Status
    # Public: Is the document done processing?
    #
    # Returns a TrueClass or FalseClass.
    def done?
      status == :done
    end

    # Public: Is the document still processing?
    #
    # Returns a TrueClass or FalseClass.
    def processing?
      status == :processing
    end

    # Public: The status of the document. Translates "Status" from Shoeboxed
    # into friendly symbol in States hash.
    #
    # Returns a Symbol.
    def status
      States[@status]
    end

    # Public: The guid used to reference the document.
    #
    # Returns a String.
    attr_reader :guid

    # Public: The document id in Shoeboxed.
    #
    # Returns a String.
    attr_reader :document_id

    # Public: The document type. Translates "DocumentType" from Shoeboxed into
    # friendly symbol in the DocumentTypes hash.
    #
    # Returns a Symbol.
    def document_type
      DocumentTypes[@document_type]
    end

    # Public: Returns the document type class.
    #
    # Returns class Receipt, BusinessCard, or OtherDocument.
    def document_type_class
      Shoeboxed.const_get(@document_type)
    end

    # Internal: Called during object instantiation.
    #
    # attributes - Hash of attributes returned from API request.
    # attributes example: {"DocumentId"=>"1806912375", "DocumentType"=>"Receipt",
    #                      "Status"=>"DONE", "guid" => "abcd1234"}
    def initialize(attributes=nil)
      attributes = attributes || {}

      # Required.
      @status = attributes.fetch("Status")
      @guid   = attributes.fetch("guid")

      # Optional, only available after the document is processed.
      @document_id   = attributes.fetch("DocumentId", nil)
      @document_type = attributes.fetch("DocumentType", nil)
    end

    States = {
      "PROCESSING" => :processing,
      "DONE"       => :done
    }

    DocumentTypes = {
      "Receipt"       => :receipt,
      "BusinessCard"  => :business_card,
      "OtherDocument" => :other_document
    }
  end
end
