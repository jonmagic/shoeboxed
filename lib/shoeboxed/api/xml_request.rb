class Shoeboxed
  module Api
    class XmlRequest
      # Public: Parsed response.
      #
      # Returns a Hash.
      def parsed_response
        response.parsed_response
      end

      # Public: Response from post request with query.
      #
      # Returns a HTTParty::Response.
      def response
        @response ||= connection.post(query)
      end

      # Internal: Query hash for request.
      #
      # Returns a Hash.
      def query
        {:xml => xml}
      end
    end
  end
end
