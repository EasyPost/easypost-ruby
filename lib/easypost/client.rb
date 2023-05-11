# frozen_string_literal: true

require_relative 'services'
require_relative 'http_client'
require_relative 'internal_utilities'
require 'json'

class EasyPost::Client
  attr_reader :open_timeout, :read_timeout, :api_base

  def initialize(api_key:, read_timeout: 60, open_timeout: 30, api_base: 'https://api.easypost.com')
    raise EasyPost::Error.new('API key is required.') if api_key.nil?

    @api_key = api_key
    @api_base = api_base
    @api_version = 'v2'
    @read_timeout = read_timeout
    @open_timeout = open_timeout
    @lib_version = File.open(File.expand_path('../../VERSION', __dir__)).read.strip

    # Make an HTTP client once, reuse it for all requests made by this client
    # Configuration is immutable, so this is safe
    @http_client = EasyPost::HttpClient.new(base_url, http_config)
  end

  SERVICE_CLASSES = [
    EasyPost::Services::Address,
    EasyPost::Services::ApiKey,
    EasyPost::Services::Batch,
    EasyPost::Services::Billing,
    EasyPost::Services::CarrierAccount,
    EasyPost::Services::CustomsInfo,
    EasyPost::Services::CustomsItem,
    EasyPost::Services::EndShipper,
    EasyPost::Services::Event,
    EasyPost::Services::Insurance,
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
  # @param body [Object] (nil) object to be dumped to JSON
  # @raise [EasyPost::Error] if the response has a non-2xx status code
  # @return [Hash] JSON object parsed from the response body
  def make_request(method, endpoint, cls = EasyPost::Models::EasyPostObject, body = nil)
    response = @http_client.request(method, endpoint, nil, body)

    status_code = response.code.to_i

    if status_code < 200 || status_code >= 300
      error = JSON.parse(response.body)['error']

      raise EasyPost::Error.new(
        error['message'],
        status_code,
        error['code'],
        error['errors'],
        response.body,
      )
    end

    EasyPost::InternalUtilities::Json.convert_json_to_object(response.body, cls)
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

  def base_url
    "#{@api_base}/#{@api_version}"
  end
end
