# frozen_string_literal: true

require 'base64'
require 'cgi'
require 'net/http'

require 'easypost/version'
require 'easypost/util'
require 'easypost/object'
require 'easypost/resource'
require 'easypost/error'
require 'easypost/connection'

# Resources
require 'easypost/address'
require 'easypost/api_key'
require 'easypost/batch'
require 'easypost/brand'
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

class EasyPost
  DEFAULT_API_BASE = 'https://api.easypost.com'
  DEFAULT_USER_AGENT = "EasyPost/v2 RubyClient/#{EasyPost::VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"

  class << self
    attr_accessor :api_key, :api_base
    attr_writer :default_connection
  end

  self.api_base = DEFAULT_API_BASE

  attr_reader :connection

  def initialize(connection)
    @connection = connection
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
  #
  # @deprecated Use {default_connection#call}
  def self.make_request(method, path, requested_api_key = api_key, body = nil)
    default_connection.call(method, path, requested_api_key, body)
  end
end
