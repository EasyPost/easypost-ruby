module EasyPost
  class Address < Resource
    attr_accessor :message # Backwards compatibility

    def self.create_and_verify(params={}, carrier=nil, api_key=nil)
      wrapped_params = {}
      wrapped_params[self.class_name().to_sym] = params
      wrapped_params[:carrier] = carrier
      response, api_key = EasyPost.request(:post, url + '/create_and_verify', api_key, wrapped_params)

      if response.has_key?(:address)
        if response.has_key?(:message)
          response[:address][:message] = response[:message]
        end
        verified_address = EasyPost::Util::convert_to_easypost_object(response[:address], api_key)
        return verified_address
      else
        raise_verification_failure
      end
    end

    def verify(params={}, carrier=nil)
      begin
        response, api_key = EasyPost.request(:get, url + '/verify?carrier=' + String(carrier), @api_key, params)
      rescue
        raise_verification_failure
      end

      if response.has_key?(:address)
        return EasyPost::Util::convert_to_easypost_object(response[:address], api_key)
      else
        raise_verification_failure
      end

      return self
    end

    def raise_verification_failure
      raise Error.new("Unable to verify address.")
    end
  end
end
