# frozen_string_literal: true

class EasyPost::Address < EasyPost::Resource
  attr_accessor :message # Backwards compatibility

  def self.create(params = {}, api_key = nil)
    url = self.url

    address = params.reject { |k, _| [:verify, :verify_strict].include?(k) }

    if params[:verify] || params[:verify_strict]
      verify = params[:verify] || []
      verify_strict = params[:verify_strict] || []

      url += '?'
      verify.each do |verification|
        url += "verify[]=#{verification}&"
      end
      verify_strict.each do |verification|
        url += "verify_strict[]=#{verification}&"
      end
    end

    response = EasyPost.make_request(:post, url, api_key, { address: address })
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def self.create_and_verify(params = {}, carrier = nil, api_key = nil)
    wrapped_params = {}
    wrapped_params[class_name.to_sym] = params
    wrapped_params[:carrier] = carrier
    response = EasyPost.make_request(:post, "#{url}/create_and_verify", api_key, wrapped_params)

    raise EasyPost::Error.new('Unable to verify address.') unless response.key?('address')

    if response.key?('message')
      response['address']['message'] = response['message']
    end

    EasyPost::Util.convert_to_easypost_object(response['address'], api_key)
  end

  def verify(params = {}, carrier = nil)
    begin
      response = EasyPost.make_request(:get, "#{url}/verify?carrier=#{String(carrier)}", @api_key, params)
    rescue StandardError
      raise EasyPost::Error.new('Unable to verify address.')
    end

    raise EasyPost::Error.new('Unable to verify address.') unless response.key?('address')

    EasyPost::Util.convert_to_easypost_object(response['address'], api_key)
  end
end
