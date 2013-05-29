class Shoeboxed
  class BusinessCard
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
