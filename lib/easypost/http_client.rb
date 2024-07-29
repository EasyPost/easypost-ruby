# frozen_string_literal: true

require 'securerandom'

class EasyPost::HttpClient
  def initialize(base_url, config, custom_client_exec = nil)
    @base_url = base_url
    @config = config
    @custom_client_exec = custom_client_exec
  end

  # Execute an HTTP request to the API.
  def request(
    method,
    path,
    headers = nil,
    params = nil,
    api_version = EasyPost::InternalUtilities::Constants::API_VERSION
  )
    # Remove leading slash from path.
    path = path[1..] if path[0] == '/'

    headers = @config[:headers].merge(headers || {})
    open_timeout = @config[:open_timeout]
    read_timeout = @config[:read_timeout]
    request_timestamp = Time.now
    request_uuid = SecureRandom.uuid

    uri = URI.parse("#{@base_url}/#{api_version}/#{path}")
    serialized_body = nil

    if params
      if [:get, :delete].include?(method)
        uri.query = URI.encode_www_form(params)
      else
        serialized_body = JSON.dump(EasyPost::InternalUtilities.objects_to_ids(params))
      end
    end

    if EasyPost::Hooks.any_subscribers?(:request)
      request_context = EasyPost::Hooks::RequestContext.new(
        method: method,
        path: uri.to_s,
        headers: headers,
        request_body: serialized_body,
        request_timestamp: request_timestamp,
        request_uuid: request_uuid,
      )
      EasyPost::Hooks.notify(:request, request_context)
    end

    # Execute the request, return the response.

    response = if @custom_client_exec
                 @custom_client_exec.call(method, uri, headers, open_timeout, read_timeout, serialized_body)
               else
                 default_request_execute(method, uri, headers, open_timeout, read_timeout, serialized_body)
               end
    response_timestamp = Time.now

    if EasyPost::Hooks.any_subscribers?(:response)
      response_context = {
        http_status: nil,
        method: method,
        path: uri.to_s,
        headers: nil,
        response_body: nil,
        request_timestamp: request_timestamp,
        response_timestamp: response_timestamp,
        client_response_object: response,
        request_uuid: request_uuid,
      }

      # If using a custom HTTP client, the user will have to infer these from the raw
      # client_response_object attribute
      if response.is_a?(Net::HTTPResponse)
        response_body = begin
                          JSON.parse(response.body)
                        rescue JSON::ParseError
                          response.body
                        end
        response_context.merge!(
          {
            http_status: response.code.to_i,
            headers: response.each_header.to_h,
            response_body: response_body,
          },
        )
      end

      EasyPost::Hooks.notify(:response, EasyPost::Hooks::ResponseContext.new(**response_context))
    end

    response
  end

  def default_request_execute(method, uri, headers, open_timeout, read_timeout, body = nil)
    # Create the request, set the headers and body if necessary.
    request = Net::HTTP.const_get(method.capitalize).new(uri)
    headers.each { |k, v| request[k] = v }
    request.body = body if body

    begin
      # Attempt to make the request and return the response.
      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: true,
        read_timeout: read_timeout,
        open_timeout: open_timeout,
      ) do |http|
        http.request(request)
      end
    rescue Net::ReadTimeout, Net::OpenTimeout, Errno::EHOSTUNREACH => e
      # Raise a timeout error if the request times out.
      raise EasyPost::Errors::TimeoutError.new(e.message)
    rescue OpenSSL::SSL::SSLError => e
      # Raise an SSL error if the request fails due to an SSL error.
      raise EasyPost::Errors::SslError.new(e.message)
    rescue StandardError => e
      # Raise an unknown HTTP error if anything else causes the request to fail to complete
      # (this is different from processing 4xx/5xx errors from the API)
      raise EasyPost::Errors::UnknownApiError.new(e.message)
    end
  end
end
