# frozen_string_literal: true

class EasyPost::HttpClient
  def initialize(base_url, config)
    @base_url = base_url
    @config = config
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

    # Create the URI and headers hash.
    uri = URI.parse("#{@base_url}/#{api_version}/#{path}")
    headers = @config[:headers].merge(headers || {})

    # Create the request, set the headers and body if necessary.
    req = Net::HTTP.const_get(method.capitalize).new(uri)
    headers.each { |k, v| req[k] = v }
    req.body = JSON.dump(EasyPost::InternalUtilities.objects_to_ids(body)) if body

    begin
      # Attempt to make the request and return the response.
      Net::HTTP.start(
        uri.host,
        uri.port, use_ssl: true, read_timeout: @config[:read_timeout], open_timeout: @config[:open_timeout],
      ) do |http|
        http.request(req)
      end
    rescue Net::ReadTimeout, Net::OpenTimeout => e
      # Raise a timeout error if the request times out.
      raise EasyPost::Errors::TimeoutError.new(e.message)
    rescue OpenSSL::SSL::SSLError => e
      # Raise an SSL error if the request fails due to an SSL error.
      raise EasyPost::Errors::SslError.new(e.message)
    rescue StandardError => e
      # Raise an unknown HTTP error if anything else causes the request to fail to complete
      # (this is different from processing 4xx/5xx errors from the API)
      raise EasyPost::Errors::UnknownHttpError.new(e.message)
    end
  end
end
