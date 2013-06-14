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
      if attributes["Categories"]
        attributes["Categories"]["Category"]
      end
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

    # Public: Date the receipt was uploaded to Shoeboxed.
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

    # Public: Card issuer, Visa, Mastercard, etc.
    #
    # Returns a String.
    def issuer
      if attributes["PaymentType"]
        attributes["PaymentType"]["issuer"]
      end
    end

    # Public: Last four digits of the card.
    #
    # Returns a String.
    def last_four_digits
      if attributes["PaymentType"]
        attributes["PaymentType"]["lastFourDigits"]
      end
    end

    # Public: The payment type, Example: "Credit/Debit Card"
    #
    # Returns a String.
    def payment_type
      if attributes["PaymentType"]
        attributes["PaymentType"]["type"]
      end
    end

    # Public: Date of sale on the receipt.
    #
    # Returns a String.
    def sell_date
      attributes["selldate"]
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
