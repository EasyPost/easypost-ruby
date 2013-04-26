module EasyPost
  class Address < Resource

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
