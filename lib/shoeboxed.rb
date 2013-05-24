require "forwardable"
require "shoeboxed/support/to_param"
require "shoeboxed/support/to_query"
require "shoeboxed/connection"
require "shoeboxed/public_api"

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

  # Public: See Shoeboxed::PublicApi#upload for documentation.
  def_delegators :public_api, :upload

  # Internal: Shoeboxed::PublicApi instance to forward api method calls to.
  #
  # Returns a Shoeboxed::PublicApi.
  def public_api
    @public_api ||= Shoeboxed::PublicApi.new(connection)
  end

  # Internal: Shoeboxed connection for making requests.
  #
  # Returns a Shoeboxed::Connection.
  def connection
    @connection ||= Shoeboxed::Connection.new(@api_user_token, @sbx_user_token)
  end
end
