# frozen_string_literal: true

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
    body = nil,
    api_version = EasyPost::InternalUtilities::Constants::API_VERSION
  )
    # Remove leading slash from path.
    path = path[1..] if path[0] == '/'

    uri = URI.parse("#{@base_url}/#{api_version}/#{path}")
    headers = @config[:headers].merge(headers || {})
    body = JSON.dump(EasyPost::InternalUtilities.objects_to_ids(body)) if body
    open_timeout = @config[:open_timeout]
    read_timeout = @config[:read_timeout]

    # Execute the request, return the response.

    if @custom_client_exec
      @custom_client_exec.call(method, uri, headers, open_timeout, read_timeout, body)
    else
      default_request_execute(method, uri, headers, open_timeout, read_timeout, body)
    end
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
        uri.port, use_ssl: true, read_timeout: read_timeout, open_timeout: open_timeout,
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
