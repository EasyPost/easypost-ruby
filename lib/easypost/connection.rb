# frozen_string_literal: true

EasyPost::Connection = Struct.new(:uri, :config, keyword_init: true) do
  # Make an HTTP request.
  def call(method, path, api_key = nil, body = nil)
    connection = create

    request = Net::HTTP.const_get(method.capitalize).new(path)
    if body
      request.body = JSON.dump(EasyPost::Util.objects_to_ids(body))
    end

    request['Content-Type'] = 'application/json'
    request['User-Agent'] = EasyPost::DEFAULT_USER_AGENT
    request['Authorization'] = EasyPost.authorization(api_key) if api_key

    response = connection.request(request)

    if (400..599).include? response.code.to_i
      error = JSON.parse(response.body)['error']
      raise EasyPost::Error.new(error['message'], response.code.to_i, error['code'], error['errors'], response.body)
    end

    if response['Content-Type'].include? 'application/json'
      JSON.parse(response.body)
    else
      response.body
    end
  rescue JSON::ParserError
    raise "Invalid response object from API, unable to decode.\n#{response.body}"
  end

  def create
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

    connection
  end
end
