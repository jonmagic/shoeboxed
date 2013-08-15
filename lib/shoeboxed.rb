require "builder"
require "forwardable"
require "shoeboxed/support/to_param"
require "shoeboxed/support/to_query"
require "shoeboxed/connection"
require "shoeboxed/documents"
require "shoeboxed/receipt"
require "shoeboxed/business_card"
require "shoeboxed/other_document"
require "shoeboxed/status"
require "shoeboxed/api/xml_request"
require "shoeboxed/api/document"
require "shoeboxed/api/status"
require "shoeboxed/api/upload"

class Shoeboxed
  extend Forwardable

  # Public: Generate an authentication url.
  #
  # options - Options hash containing :app_name and :callback_url.
  #
  # Example:
  #
  #    Shoeboxed.authentication_url \
  #      :app_name => "Hoyt Accounting",
  #      :callback_url => "http://shoeboxed.herokuapp.com"
  # => "https://api.shoeboxed.com/v1/ws/api.htm?SignIn=1&appname=Hoyt+Accounting&appurl=http%3A%2F%2Fshoeboxed.herokuapp.com&appparams="
  #
  # Returns a String.
  def self.authentication_url(options=nil)
    params = {
      "appname"   => options.fetch(:app_name),
      "appurl"    => options.fetch(:callback_url),
      "SignIn"    => 1,
      # FIX: You should be able to pass in a :params hash in the options hash
      # which then gets encoded and the keys and values are returned by
      # Shoeboxed in the callback post. Assuming this is a way to add an extra
      # layer of security and ensure the request was initiated by your app.
      "appparams" => nil
    }

    "https://api.shoeboxed.com/v1/ws/api.htm?#{params.to_query}"
  end

  # Internal: Called during object instantiation. The args array sent to #new
  # is passed on to the initialize method.
  #
  # options - Hash of options.
  def initialize(options=nil)
    options = options || {}
    @api_user_token = options.fetch(:api_user_token)
    @sbx_user_token = options.fetch(:sbx_user_token)
  end

  # Public: See Shoeboxed::Documents#upload for documentation.
  def_delegators :documents, :upload

  # Public: See Shoeboxed::Documents#status for documentation.
  def_delegators :documents, :status

  # Public: See Shoeboxed::Documents#find_by_guid for documentation.
  def_delegators :documents, :find_by_guid

  # Public: See Shoeboxed::Documents#find_by_type_and_id for documentation.
  def_delegators :documents, :find_by_type_and_id

  # Internal: Shoeboxed::Document instance to forward api method calls to.
  #
  # Returns a Shoeboxed::Document.
  def documents
    @documents ||= Shoeboxed::Documents.new(connection)
  end

  # Internal: Shoeboxed connection for making requests.
  #
  # Returns a Shoeboxed::Connection.
  def connection
    @connection ||= Shoeboxed::Connection.new(@api_user_token, @sbx_user_token)
  end

  # Raised on non 200 response codes.
  class InternalServerError < Exception; end

  # Raised when parsed response hash has 'Error' key.
  class Error < Exception; end

  # Raised when request key is not present in parsed response hash.
  class UnrecognizedResponse < Exception; end
end
