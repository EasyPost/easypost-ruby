# frozen_string_literal: true

require_relative 'services'
require_relative 'http_client'
require 'json'

class EasyPost::Client
  def initialize(api_key:, read_timeout: 60, open_timeout: 30, api_base: 'https://api.easypost.com')
    raise EasyPost::Error.new('API key is required.') if api_key.nil?

    @configuration = EasyPost::ClientConfiguration.new(
      api_key,
      read_timeout,
      open_timeout,
      api_base,
    )

    # Make an HTTP client once, reuse it for all requests made by this client
    # Configuration is immutable, so this is safe
    @http_client = @configuration.new_http_client
  end

  def address
    @address ||= EasyPost::Services::Address.new(self)
  end

  # Make an HTTP request
  #
  # @param method [Symbol] the HTTP Verb (get, method, put, post, etc.)
  # @param endpoint [String] URI path of the resource
  # @param body [Object] (nil) object to be dumped to JSON
  # @raise [EasyPost::Error] if the response has a non-2xx status code
  # @return [Hash] JSON object parsed from the response body
  def make_request(method, endpoint, cls, body = nil)
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
end

private

class EasyPost::ClientConfiguration
  def initialize(api_key, read_timeout = 60, open_timeout = 30, api_base = 'https://api.easypost.com')
    @api_key = api_key
    @api_base = api_base
    @api_version = 'v2'
    @read_timeout = read_timeout
    @open_timeout = open_timeout
    @lib_version = File.open(File.expand_path('../../VERSION', __dir__)).read.strip
  end

  # Make an HTTP client using the current state of the configuration
  def new_http_client
    EasyPost::HttpClient.new(base_url, http_config)
  end

  protected

  def http_config
    http_config = {
      read_timeout: @read_timeout,
      open_timeout: @open_timeout,
      verify_mode: OpenSSL::SSL::VERIFY_PEER,
      headers: default_headers,
    }

    ruby_version = Gem::Version.new(EasyPost::InternalUtilities::System.ruby_version)
    if ruby_version >= Gem::Version.new('2.5.0')
      http_config[:min_version] = OpenSSL::SSL::TLS1_2_VERSION
    else
      http_config[:ssl_version] = :TLSv1_2 # rubocop:disable Naming/VariableNumber
    end

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
