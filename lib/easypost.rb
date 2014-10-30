require 'cgi'
require 'set'
require 'openssl'
require 'rest_client'
require 'multi_json'

# Resources
require 'easypost/version'
require 'easypost/util'
require 'easypost/object'
require 'easypost/resource'
require 'easypost/address'
require 'easypost/parcel'
require 'easypost/customs_item'
require 'easypost/customs_info'
require 'easypost/shipment'
require 'easypost/rate'
require 'easypost/postage_label'
require 'easypost/scan_form'
require 'easypost/refund'
require 'easypost/event'
require 'easypost/batch'
require 'easypost/tracker'
require 'easypost/item'
require 'easypost/container'
require 'easypost/order'
require 'easypost/pickup'
require 'easypost/pickup_rate'

require 'easypost/error'

module EasyPost
  @@api_key = nil
  @@api_base = 'https://api.easypost.com/v2'
  @@api_version = nil
  @@open_timeout = 30
  @@timeout = 60

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

  def self.http_config
    @@http_config ||= {
      timeout: 60,
      open_timeout: 30,
      verify_ssl: false
    }
  end

  def self.http_config=(http_config_params)
    self.http_config.merge!(http_config_params)
  end

  def self.request(method, url, api_key, params={}, headers={})
    api_key ||= @@api_key
    raise Error.new('No API key provided.') unless api_key

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

    headers = {
      :user_agent => "EasyPost/v2 RubyClient/#{VERSION}",
      :authorization => "Bearer #{api_key}",
      :content_type => 'application/x-www-form-urlencoded'
    }.merge(headers)

    opts = http_config.merge(
      {
        :method => method,
        :url => url,
        :headers => headers,
        :payload => payload
      }
    )

    begin
      response = execute_request(opts)
    rescue RestClient::ExceptionWithResponse => e
      if response_code = e.http_code and response_body = e.http_body
        begin
          response_json = MultiJson.load(response_body, :symbolize_keys => true)
        rescue MultiJson::DecodeError
          raise Error.new("Invalid response from API, unable to decode.", response_code, response_body)
        end
        begin
          raise NoMethodError if response_json[:error][:message] == nil
          raise Error.new(response_json[:error][:message], response_code, response_body, response_json)
        rescue NoMethodError, TypeError
          raise Error.new(response_json[:error], response_code, response_body, response_json)
        end
      else
        raise Error.new(e.message)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      raise Error.new(e.message)
    end

    begin
      response_json = MultiJson.load(response.body, :symbolize_keys => true)
    rescue MultiJson::DecodeError
      raise Error.new("Invalid response object from API, unable to decode.", response.code, response.body)
    end

    return [response_json, api_key]
  end

  private

  def self.execute_request(opts)
    RestClient::Request.execute(opts)
  end
end
