require "base64"
require "cgi"
require "net/http"

# Resources
require "easypost/version"
require "easypost/util"
require "easypost/object"
require "easypost/resource"
require "easypost/address"
require "easypost/parcel"
require "easypost/customs_item"
require "easypost/customs_info"
require "easypost/shipment"
require "easypost/rate"
require "easypost/postage_label"
require "easypost/scan_form"
require "easypost/refund"
require "easypost/insurance"
require "easypost/event"
require "easypost/batch"
require "easypost/tracker"
require "easypost/item"
require "easypost/order"
require "easypost/pickup"
require "easypost/pickup_rate"
require "easypost/printer"
require "easypost/print_job"
require "easypost/carrier_account"
require "easypost/user"
require "easypost/report"
require "easypost/webhook"

require "easypost/error"

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
    @http_config = {
      timeout: 60,
      open_timeout: 30,
      verify_ssl: OpenSSL::SSL::VERIFY_PEER,
    }

    ruby_version = Gem::Version.new(RUBY_VERSION)
    if ruby_version >= Gem::Version.new("2.5.0")
      @http_config[:min_version] = OpenSSL::SSL::TLS1_2_VERSION
    else
      @http_config[:ssl_version] = :TLSv1_2
    end

    @http_config
  end

  def self.http_config
    @http_config ||= reset_http_config
  end

  def self.http_config=(http_config_params)
    http_config.merge!(http_config_params)
  end

  def self.make_client(uri)
    client = if http_config[:proxy]
               proxy_uri = URI(http_config[:proxy])
               Net::HTTP.new(
                 uri.host,
                 uri.port,
                 proxy_uri.host,
                 proxy_uri.port,
                 proxy_uri.user,
                 proxy_uri.password
               )
             else
               Net::HTTP.new(uri.host, uri.port)
             end
    client.use_ssl = true

    http_config.each do |name, value|
      # Discrepancies between RestClient and Net::HTTP.
      if name == :verify_ssl
        name = :verify_mode
      elsif name == :timeout
        name = :read_timeout
      end

      # Handled in the creation of the client.
      if name == :proxy
        next
      end

      client.send("#{name}=", value)
    end

    client
  end

  def self.make_request(method, path, api_key=nil, body=nil)
    client = make_client(URI(@api_base))

    request = Net::HTTP.const_get(method.capitalize).new(path)
    if body
      request.body = JSON.dump(Util.objects_to_ids(body))
    end

    request["Content-Type"] = "application/json"
    request["User-Agent"] = "EasyPost/v2 RubyClient/#{VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    if api_key = api_key || @api_key
      request["Authorization"] = "Basic #{Base64.strict_encode64("#{api_key}:")}"
    end

    response = client.request(request)

    if (400..599).include? response.code.to_i
      error = JSON.parse(response.body)["error"]
      raise Error.new(error["message"], response.code.to_i, error["code"], error["errors"], response.body)
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
