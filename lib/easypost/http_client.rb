# frozen_string_literal: true

class EasyPost::HttpClient
  def initialize(base_url, config)
    @base_url = base_url
    @config = config
  end

  # Execute an HTTP request to the API.
  def request(method, path, headers = nil, body = nil)
    # Remove leading slash from path.
    path = path[1..] if path[0] == '/'

    # Create the URI and headers hash.
    uri = URI.parse("#{@base_url}/#{path}")
    headers = @config[:headers].merge(headers || {})

    # Create the request, set the headers and body if necessary.
    request = Net::HTTP.const_get(method.capitalize).new(uri)
    headers.each { |k, v| request[k] = v }
    request.body = JSON.dump(body) if body

    # Execute the request, return the response.
    Net::HTTP.start(
      uri.host,
      uri.port, use_ssl: true, read_timeout: @config[:read_timeout], open_timeout: @config[:open_timeout],
    ) do |http|
      http.request(request)
    end
  end
end
