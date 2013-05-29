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

      # Internal: Takes builder and block and finishes building XML adding
      # in authentication credentials.
      #
      # Returns a String.
      def authed_xml_as_string(builder, &block)
        builder.instruct!(:xml, :version=>"1.0", :encoding=>"UTF-8")
        builder.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do
          builder.RequesterCredentials do
            builder.ApiUserToken(connection.api_user_token)
            builder.SbxUserToken(connection.sbx_user_token)
          end
          block.call
        end

        builder.target!
      end
    end
  end
end
