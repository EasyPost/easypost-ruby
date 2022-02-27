# frozen_string_literal: true

EasyPost::Connection = Struct.new(:uri, :config, keyword_init: true) do
  attr_reader :connection

  def initialize(uri:, config:)
    super

    @connection =
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
  end

  # Make an HTTP request.
  def call(method, path, api_key = nil, body = nil)
    request = Net::HTTP.const_get(method.capitalize).new(path)
    request.body = JSON.dump(EasyPost::Util.objects_to_ids(body)) if body

    EasyPost.default_headers.each_pair { |h, v| request[h] = v }
    request['Authorization'] = EasyPost.authorization(api_key) if api_key

    response = connection.request(request)

    EasyPost.parse_response(
      status: response.code.to_i,
      body: response.body,
      json: response['Content-Type'].start_with?('application/json'),
    )
  end
end
