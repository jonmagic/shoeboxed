class Shoeboxed
  class Receipt
    # Public: Credit card account currency.
    #
    # Returns a String.
    def account_currency
      attributes["accountCurrency"]
    end

    # Public: Expense categories for this receipt.
    #
    # Returns a String.
    def categories
      attributes["Categories"]["Category"]
    end

    # Public: Conversion rate from document currency to account currency.
    #
    # Returns a String.
    def conversion_rate
      attributes["conversionRate"]
    end

    # Public: Converted total. Assuming this is calculated using the document
    # total and the conversion rate.
    #
    # Returns a String.
    def converted_total
      attributes["convertedTotal"]
    end

    # Public: Date on the receipt.
    #
    # Returns a String.
    def date
      attributes["date"]
    end

    # Public: Receipt currency.
    #
    # Returns a String.
    def document_currency
      attributes["documentCurrency"]
    end

    # Public: Document (receipt) total
    #
    # Returns a String.
    def document_total
      attributes["documentTotal"]
    end

    # Public: Shoeboxed id for the receipt.
    #
    # Returns a String.
    def id
      attributes["id"]
    end

    # Public: Store (or vendor) on the receipt.
    #
    # Returns a String.
    def store
      attributes["store"]
    end

    # Internal: Called during object instantiation.
    #
    # attributes - Hash of attributes returned from API request.
    def initialize(attributes=nil)
      @attributes = attributes || {}
    end

    # Internal: Document attributes hash.
    attr_reader :attributes
  end
end
