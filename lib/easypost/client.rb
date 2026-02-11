# frozen_string_literal: true

require_relative 'services'
require_relative 'http_client'
require_relative 'internal_utilities'
require 'json'
require 'securerandom'

class EasyPost::Client
  attr_reader :open_timeout, :read_timeout, :api_base

  # Initialize a new Client object
  # @param api_key [String] the API key to be used for requests
  # @param read_timeout [Integer] (60) the number of seconds to wait for a response before timing out
  # @param open_timeout [Integer] (30) the number of seconds to wait for the connection to open before timing out
  # @param api_base [String] ('https://api.easypost.com') the base URL for the API
  # @param custom_client_exec [Proc] (nil) a custom client execution block to be used for requests instead of the default HTTP client (function signature: method, uri, headers, open_timeout, read_timeout, body = nil)
  # @return [EasyPost::Client] the client object
  def initialize(api_key:, read_timeout: 60, open_timeout: 30, api_base: 'https://api.easypost.com',
                 custom_client_exec: nil)
    raise EasyPost::Errors::MissingParameterError.new('api_key') if api_key.nil?

    @api_key = api_key
    @api_base = api_base
    @api_version = 'v2'
    @read_timeout = read_timeout
    @open_timeout = open_timeout
    @lib_version = File.open(File.expand_path('../../VERSION', __dir__)).read.strip

    # Make an HTTP client once, reuse it for all requests made by this client
    # Configuration is immutable, so this is safe
    @http_client = EasyPost::HttpClient.new(api_base, http_config, custom_client_exec)
  end

  SERVICE_CLASSES = [
    EasyPost::Services::Address,
    EasyPost::Services::ApiKey,
    EasyPost::Services::Batch,
    EasyPost::Services::BetaRate,
    EasyPost::Services::BetaReferralCustomer,
    EasyPost::Services::Billing,
    EasyPost::Services::CarrierAccount,
    EasyPost::Services::CarrierMetadata,
    EasyPost::Services::CarrierType,
    EasyPost::Services::Claim,
    EasyPost::Services::CustomerPortal,
    EasyPost::Services::CustomsInfo,
    EasyPost::Services::CustomsItem,
    EasyPost::Services::Embeddable,
    EasyPost::Services::EndShipper,
    EasyPost::Services::Event,
    EasyPost::Services::FedexRegistration,
    EasyPost::Services::Insurance,
    EasyPost::Services::Luma,
    EasyPost::Services::Order,
    EasyPost::Services::Parcel,
    EasyPost::Services::Pickup,
    EasyPost::Services::Rate,
    EasyPost::Services::ReferralCustomer,
    EasyPost::Services::Refund,
    EasyPost::Services::Report,
    EasyPost::Services::ScanForm,
    EasyPost::Services::Shipment,
    EasyPost::Services::SmartRate,
    EasyPost::Services::Tracker,
    EasyPost::Services::User,
    EasyPost::Services::Webhook,
  ].freeze

  # Loop over the SERVICE_CLASSES to automatically define the method and instance variable instead of manually define it
  SERVICE_CLASSES.each do |cls|
    define_method(EasyPost::InternalUtilities.to_snake_case(cls.name.split('::').last)) do
      instance_variable_set("@#{EasyPost::InternalUtilities.to_snake_case(cls.name.split('::').last)}", cls.new(self))
    end
  end

  # Make an HTTP request
  #
  # @param method [Symbol] the HTTP Verb (get, method, put, post, etc.)
  # @param endpoint [String] URI path of the resource
  # @param params [Object] (nil) object to be used as the request parameters
  # @param api_version [String] the version of API to hit
  # @raise [EasyPost::Errors::EasyPostError] if the response has a non-2xx status code
  # @return [Hash] JSON object parsed from the response body
  def make_request(
    method,
    endpoint,
    params = nil,
    api_version = EasyPost::InternalUtilities::Constants::API_VERSION
  )
    response = @http_client.request(method, endpoint, nil, params, api_version)

    potential_error = EasyPost::Errors::ApiError.handle_api_error(response)
    raise potential_error unless potential_error.nil?

    EasyPost::InternalUtilities::Json.parse_json(response.body)
  end

  # Subscribe a request hook
  #
  # @param name [Symbol] the name of the hook. Defaults ot a ranom hexadecimal-based symbol
  # @param block [Block] a code block that will be executed before a request is made
  # @return [Symbol] the name of the request hook
  def subscribe_request_hook(name = SecureRandom.hex.to_sym, &block)
    EasyPost::Hooks.subscribe(:request, name, block)
  end

  # Unsubscribe a request hook
  #
  # @param name [Symbol] the name of the hook
  # @return [Block] the hook code block
  def unsubscribe_request_hook(name)
    EasyPost::Hooks.unsubscribe(:request, name)
  end

  # Unsubscribe all request hooks
  #
  # @return [Hash] a hash containing all request hook subscriptions
  def unsubscribe_all_request_hooks
    EasyPost::Hooks.unsubscribe_all(:request)
  end

  # Subscribe a response hook
  #
  # @param name [Symbol] the name of the hook. Defaults ot a ranom hexadecimal-based symbol
  # @param block [Block] a code block that will be executed upon receiving the response from a request
  # @return [Symbol] the name of the response hook
  def subscribe_response_hook(name = SecureRandom.hex.to_sym, &block)
    EasyPost::Hooks.subscribe(:response, name, block)
  end

  # Unsubscribe a response hook
  #
  # @param name [Symbol] the name of the hook
  # @return [Block] the hook code block
  def unsubscribe_response_hook(name)
    EasyPost::Hooks.unsubscribe(:response, name)
  end

  # Unsubscribe all response hooks
  #
  # @return [Hash] a hash containing all response hook subscriptions
  def unsubscribe_all_response_hooks
    EasyPost::Hooks.unsubscribe_all(:response)
  end

  private

  def http_config
    http_config = {
      read_timeout: @read_timeout,
      open_timeout: @open_timeout,
      headers: default_headers,
    }

    http_config[:min_version] = OpenSSL::SSL::TLS1_2_VERSION
    http_config
  end

  def default_headers
    {
      'Content-Type' => 'application/json',
      'User-Agent' => user_agent,
      'Authorization' => authorization,
    }
  end

  def user_agent
    ruby_version = EasyPost::InternalUtilities::System.ruby_version
    ruby_patchlevel = EasyPost::InternalUtilities::System.ruby_patchlevel

    "EasyPost/#{@api_version} " \
      "RubyClient/#{@lib_version} " \
      "Ruby/#{ruby_version}-p#{ruby_patchlevel} " \
      "OS/#{EasyPost::InternalUtilities::System.os_name} " \
      "OSVersion/#{EasyPost::InternalUtilities::System.os_version} " \
      "OSArch/#{EasyPost::InternalUtilities::System.os_arch}"
  end

  def authorization
    "Bearer #{@api_key}"
  end
end
