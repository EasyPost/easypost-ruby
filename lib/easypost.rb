# frozen_string_literal: true

require 'base64'
require 'cgi'
require 'net/http'

require_relative 'easypost/version'
require_relative 'easypost/util'
require_relative 'easypost/object'
require_relative 'easypost/resource'
require_relative 'easypost/error'
require_relative 'easypost/connection'

# Resources
require_relative 'easypost/address'
require_relative 'easypost/api_key'
require_relative 'easypost/batch'
require_relative 'easypost/brand'
require_relative 'easypost/carrier_account'
require_relative 'easypost/carrier_type'
require_relative 'easypost/customs_info'
require_relative 'easypost/customs_item'
require_relative 'easypost/event'
require_relative 'easypost/insurance'
require_relative 'easypost/order'
require_relative 'easypost/parcel'
require_relative 'easypost/pickup_rate'
require_relative 'easypost/pickup'
require_relative 'easypost/postage_label'
require_relative 'easypost/rate'
require_relative 'easypost/refund'
require_relative 'easypost/report'
require_relative 'easypost/scan_form'
require_relative 'easypost/shipment'
require_relative 'easypost/tax_identifier'
require_relative 'easypost/tracker'
require_relative 'easypost/user'
require_relative 'easypost/webhook'

module EasyPost
  DEFAULT_API_BASE = 'https://api.easypost.com'
  DEFAULT_USER_AGENT = "EasyPost/v2 RubyClient/#{EasyPost::VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"

  class << self
    attr_accessor :api_key, :api_base
    attr_writer :default_connection
  end

  self.api_base = DEFAULT_API_BASE

  def self.default_headers
    @default_headers ||= {
      'Content-Type' => 'application/json',
      'User-Agent' => EasyPost::DEFAULT_USER_AGENT,
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
  end

  # Create an EasyPost Client.
  #
  # @deprecated
  def self.make_client(url)
    EasyPost::Connection.new(uri: URI(url), config: http_config).create
  end

  # Make an HTTP request.
  def self.make_request(method, path, requested_api_key = api_key, body = nil)
    default_connection.call(method, path, requested_api_key, body)
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

    json ? JSON.parse(body) : body
  rescue JSON::ParserError
    raise "Invalid response object from API, unable to decode.\n#{body}"
  end
end
