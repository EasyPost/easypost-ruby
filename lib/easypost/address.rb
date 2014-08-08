module EasyPost
  class Address < Resource

    def self.create_and_verify(params={}, api_key=nil)
      wrapped_params = {}
      wrapped_params[self.class_name().to_sym] = params
      response, api_key = EasyPost.request(:post, url + '/create_and_verify', api_key, wrapped_params)

      if response.has_key?(:address)
        if response.has_key?(:message)
          response[:address][:message] = response[:message]
        end
        verified_address = EasyPost::Util::convert_to_easypost_object(response[:address], api_key)
        return verified_address
      else
        raise Error.new("Unable to verify address.")
      end
    end

    def verify(params={})
      response, api_key = EasyPost.request(:get, url + '/verify', @api_key, params)

      if response.has_key?(:address)
        if response.has_key?(:message)
          response[:address][:message] = response[:message]
        end
        verified_address = EasyPost::Util::convert_to_easypost_object(response[:address], api_key)
        return verified_address
      else
        raise Error.new("Unable to verify address.")
      end

      return self
    end

  end
end
