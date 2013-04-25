require 'cgi'
require 'set'
require 'openssl'
require 'rest_client'
require 'multi_json'

# Resources
require 'easypost/util'
require 'easypost/object'
require 'easypost/resource'
require 'easypost/address'
require 'easypost/scan_form'

# Errors
require 'easypost/errors/easypost_error'
require 'easypost/errors/api_error'
require 'easypost/errors/network_error'
require 'easypost/errors/invalid_request_error'
require 'easypost/errors/authentication_error'

module EasyPost
  @@api_key = nil
  # @@api_base = 'https://www.geteasypost.com/api/v2'
  @@api_base = 'http://localhost:5000/api/v2'
  @@api_version = nil

  def self.api_url(url='')
    @@api_base + url
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.api_base=(api_base)
    @@api_base = api_base
  end

  def self.api_base
    @@api_base
  end

  def self.api_version=(version)
    @@api_version = version
  end

  def self.api_version
    @@api_version
  end

  def self.request(method, url, api_key, params={}, headers={})
    api_key ||= @@api_key
    raise AuthenticationError.new('No API key provided.  (HINT: set your API key using "EasyPost.api_key = <API-KEY>".  You can generate API keys from the EasyPost web interface. See https://www.geteasypost.com/docs for details, or email contact@easypost.co if you have any questions.)') unless api_key

    ssl_opts = { :verify_ssl => false }

    params = Util.objects_to_ids(params)
    url = self.api_url(url)
    case method.to_s.downcase.to_sym
    when :get, :head, :delete
      # Make params into GET parameters
      if params && params.count > 0
        query_string = Util.flatten_params(params).collect{|key, value| "#{key}=#{Util.url_encode(value)}"}.join('&')
        url += "#{URI.parse(url).query ? '&' : '?'}#{query_string}"
      end
      payload = nil
    else
      payload = Util.flatten_params(params).collect{|(key, value)| "#{key}=#{Util.url_encode(value)}"}.join('&')
    end

    puts url
    puts payload
    puts '******************'

    headers = {
      :user_agent => "EasyPost/v2 RubyClient/1.2",
      :authorization => "Bearer #{api_key}",
      :content_type => 'application/x-www-form-urlencoded'
    }.merge(headers)

    opts = {
      :method => method,
      :url => url,
      :headers => headers,
      :open_timeout => 30,
      :payload => payload,
      :timeout => 60
    }.merge(ssl_opts)

    begin
      response = execute_request(opts)
    rescue RestClient::ExceptionWithResponse => e
      if response_code = e.http_code and response_body = e.http_body
        self.handle_api_error(response_code, response_body)
      else
        self.handle_network_error(e)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      self.handle_network_error(e)
    end

    begin
      response_json = MultiJson.load(response.body, :symbolize_keys => true)
    rescue MultiJson::DecodeError
      raise APIError.new("Invalid response object from API: #{response.body.inspect} (HTTP response code was #{response.code})", response.code, response.body)
    end

    return [response_json, api_key]
  end

  private

  def self.execute_request(opts)
    RestClient::Request.execute(opts)
  end

  def self.handle_api_error(response_code, response_body)
    begin
      error_obj = MultiJson.load(response_body, :symbolize_keys => true)
      # error_obj = Util.symbolize_names(error_obj)
      error = error_obj[:error] or raise EasyPostError.new # escape from parsing
    rescue MultiJson::DecodeError, EasyPostError
      raise APIError.new("Invalid response object from API: #{response_body.inspect} (HTTP response code was #{response_code})", response_code, response_body)
    end

    case response_code
    when 400, 404 then
      raise invalid_request_error(error, response_code, response_body, error_obj)
    when 401
      raise authentication_error(error, response_code, response_body, error_obj)
    when 402
      raise card_error(error, response_code, response_body, error_obj)
    else
      raise api_error(error, response_code, response_body, error_obj)
    end
  end

  def self.invalid_request_error(error, response_code, response_body, error_obj)
    InvalidRequestError.new(error[:message], error[:param], response_code, response_body, error_obj)
  end

  def self.authentication_error(error, response_code, response_body, error_obj)
    AuthenticationError.new(error[:message], response_code, response_body, error_obj)
  end

  def self.api_error(error, response_code, response_body, error_obj)
    APIError.new(error[:message], response_code, response_body, error_obj)
  end

  def self.handle_network_error(e)
    
    message += "\n\n(Network error: #{e.message})"
    raise NetworkError.new(message)
  end
end
