# frozen_string_literal: true

require_relative 'services'
require_relative 'client_configuration'
require_relative 'http_client'
require_relative 'utilities/static_mapper'
require 'json'

class EasyPost::Client
  def initialize(api_key, read_timeout = 60, open_timeout = 30, api_base = nil)
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
