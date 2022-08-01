# frozen_string_literal: true

require 'base64'
require 'cgi'
require 'net/http'

require 'easypost/version'
require 'easypost/object'
require 'easypost/resource'
require 'easypost/error'
require 'easypost/connection'

# Resources
require 'easypost/address'
require 'easypost/api_key'
require 'easypost/batch'
require 'easypost/billing'
require 'easypost/brand'
require 'easypost/carbon_offset'
require 'easypost/carrier_account'
require 'easypost/carrier_type'
require 'easypost/customs_info'
require 'easypost/customs_item'
require 'easypost/event'
require 'easypost/insurance'
require 'easypost/order'
require 'easypost/parcel'
require 'easypost/pickup_rate'
require 'easypost/pickup'
require 'easypost/postage_label'
require 'easypost/rate'
require 'easypost/refund'
require 'easypost/report'
require 'easypost/scan_form'
require 'easypost/shipment'
require 'easypost/tax_identifier'
require 'easypost/tracker'
require 'easypost/user'
require 'easypost/webhook'
require 'easypost/beta'

require 'easypost/util'

module EasyPost
  DEFAULT_API_BASE = 'https://api.easypost.com'

  class << self
    attr_accessor :api_key, :api_base
    attr_writer :default_connection
  end

  self.api_base = DEFAULT_API_BASE

  def self.user_agent
    @user_agent ||=
      "EasyPost/v2 RubyClient/#{EasyPost::VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} " \
      "OS/#{EasyPost::Util.os_name} OSVersion/#{EasyPost::Util.os_version} " \
      "OSArch/#{EasyPost::Util.os_arch}"
  end

  def self.default_headers
    @default_headers ||= {
      'Content-Type' => 'application/json',
      'User-Agent' => user_agent,
    }
  end

  def self.default_connection
    @default_connection ||= EasyPost::Connection.new(
      uri: URI(api_base),
      config: http_config,
    )
  end

  def self.authorization(key)
    "Basic #{Base64.strict_encode64("#{key}:")}"
  end

  # Reset the HTTP config.
  def self.reset_http_config
    http_config.clear
    self.default_connection = nil
  end

  def self.default_http_config
    http_config = {
      timeout: 60,
      open_timeout: 30,
      verify_ssl: OpenSSL::SSL::VERIFY_PEER,
    }

    ruby_version = Gem::Version.new(RUBY_VERSION)
    if ruby_version >= Gem::Version.new('2.5.0')
      http_config[:min_version] = OpenSSL::SSL::TLS1_2_VERSION
    else
      http_config[:ssl_version] = :TLSv1_2 # rubocop:disable Naming/VariableNumber
    end

    http_config
  end

  # Get the HTTP config.
  def self.http_config
    @http_config ||= default_http_config
  end

  # Set the HTTP config.
  def self.http_config=(http_config_params)
    http_config.merge!(http_config_params)

    self.default_connection = nil
  end

  # Create an EasyPost Client.
  #
  # @deprecated
  def self.make_client(url)
    EasyPost::Connection.new(uri: URI(url), config: http_config).create
  end

  # Make an HTTP request against the {default_connection}
  #
  # @param method [Symbol] the HTTP Verb (get, method, put, post, etc.)
  # @param path [String] URI path of the resource
  # @param requested_api_key [String] ({EasyPost.api_key}) key set Authorization header.
  # @param body [Object] (nil) object to be dumped to JSON
  # @raise [EasyPost::Error] if the response has a non-2xx status code
  # @return [Hash] JSON object parsed from the response body
  def self.make_request(method, path, api_key = nil, body = nil)
    default_connection.call(method, path, api_key || EasyPost.api_key, body)
  end

  def self.parse_response(status:, body:, json:)
    if status >= 400
      error = JSON.parse(body)['error']

      raise EasyPost::Error.new(
        error['message'],
        status,
        error['code'],
        error['errors'],
        body,
      )
    end

    json || !body.nil? && !body.match(/\A\s+\z/) ? JSON.parse(body) : body
  rescue JSON::ParserError
    raise "Invalid response object from API, unable to decode.\n#{body}"
  end
end
