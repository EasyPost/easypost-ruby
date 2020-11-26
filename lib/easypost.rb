require "base64"
require "cgi"
require "net/http"

require "easypost/version"
require "easypost/util"
require "easypost/object"
require "easypost/resource"
require "easypost/error"

# Resources
require "easypost/address"
require "easypost/batch"
require "easypost/carrier_account"
require "easypost/carrier_type"
require "easypost/customs_info"
require "easypost/customs_item"
require "easypost/event"
require "easypost/insurance"
require "easypost/order"
require "easypost/parcel"
require "easypost/pickup_rate"
require "easypost/pickup"
require "easypost/postage_label"
require "easypost/print_job"
require "easypost/printer"
require "easypost/rate"
require "easypost/refund"
require "easypost/report"
require "easypost/scan_form"
require "easypost/shipment"
require "easypost/tracker"
require "easypost/user"
require "easypost/webhook"

require "easypost/error"

require "easypost/persistent_http_client"

module EasyPost
  @api_key = nil
  @api_base = "https://api.easypost.com"

  def self.api_key=(api_key)
    @api_key = api_key
  end

  def self.api_key
    @api_key
  end

  def self.api_base=(api_base)
    @api_base = api_base
  end

  def self.api_base
    @api_base
  end

  def self.reset_http_config
    EasyPost::PersistentHttpClient::HttpConfig.reset_config
  end

  def self.http_config
    EasyPost::PersistentHttpClient::HttpConfig.config
  end

  def self.http_config=(http_config_params)
    EasyPost::PersistentHttpClient::HttpConfig.config = http_config_params
  end

  def self.make_client(uri)
    EasyPost::PersistentHttpClient.get(uri)
  end

  def self.make_request(method, path, api_key=nil, body=nil)
    client = make_client(URI(@api_base))

    request = Net::HTTP.const_get(method.capitalize).new(path)
    if body
      request.body = JSON.dump(EasyPost::Util.objects_to_ids(body))
    end

    request["Content-Type"] = "application/json"
    request["User-Agent"] = "EasyPost/v2 RubyClient/#{VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    if api_key = api_key || @api_key
      request["Authorization"] = "Basic #{Base64.strict_encode64("#{api_key}:")}"
    end

    response = client.request(request)

    if (400..599).include? response.code.to_i
      error = JSON.parse(response.body)["error"]
      raise EasyPost::Error.new(error["message"], response.code.to_i, error["code"], error["errors"], response.body)
    end

    if response["Content-Type"].include? "application/json"
      JSON.parse(response.body)
    else
      response.body
    end
  rescue JSON::ParserError
    raise RuntimeError.new(
      "Invalid response object from API, unable to decode.\n#{response.body}"
    )
  end
end
