# frozen_string_literal: true

EasyPost::Connection = Struct.new(:uri, :config, keyword_init: true) do
  # Make an HTTP request with Ruby's {Net::HTTP}
  #
  # @param method [Symbol] the HTTP Verb (get, method, put, post, etc.)
  # @param path [String] URI path of the resource
  # @param requested_api_key [String] ({EasyPost.api_key}) key set Authorization header.
  # @param body [String] (nil) body of the request
  # @raise [EasyPost::Error] if the response has a non-2xx status code
  # @return [Hash] JSON object parsed from the response body
  def call(method, path, api_key = nil, body = nil)
    if api_key.nil?
      raise EasyPost::Error, 'No API key provided.'
    end

    connection =
      if config[:proxy]
        proxy_uri = URI(config[:proxy])
        Net::HTTP.new(
          uri.host,
          uri.port,
          proxy_uri.host,
          proxy_uri.port,
          proxy_uri.user,
          proxy_uri.password,
        )
      else
        Net::HTTP.new(uri.host, uri.port)
      end

    connection.use_ssl = true

    config.each do |name, value|
      # Discrepancies between RestClient and Net::HTTP.
      case name
      when :verify_ssl
        name = :verify_mode
      when :timeout
        name = :read_timeout
      end

      # Handled in the creation of the client.
      if name == :proxy
        next
      end

      connection.public_send("#{name}=", value)
    end

    request = Net::HTTP.const_get(method.capitalize).new(path)
    request.body = JSON.dump(EasyPost::InternalUtilities.objects_to_ids(body)) if body

    EasyPost.default_headers.each_pair { |h, v| request[h] = v }
    request['Authorization'] = EasyPost.authorization(api_key)

    response = connection.request(request)
    response_is_json = response['Content-Type'] ? response['Content-Type'].start_with?('application/json') : false

    EasyPost.parse_response(
      status: response.code.to_i,
      body: response.body,
      json: response_is_json,
    )
  end
end
