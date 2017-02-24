module EasyPost
  class Address < Resource
    attr_accessor :message # Backwards compatibility

    def self.create(params={}, api_key=nil)
      url = self.url

      if params[:verify] || params[:verify_strict]
        verify = params.delete(:verify) || []
        verify_strict = params.delete(:verify_strict) || []

        url += "?"
        verify.each do |verification|
          url += "verify[]=#{verification}&"
        end
        verify_strict.each do |verification|
          url += "verify_strict[]=#{verification}&"
        end
      end

      response, api_key = EasyPost.request(:post, url, api_key, {address: params})
      return Util.convert_to_easypost_object(response, api_key)
    end

    def self.create_and_verify(params={}, carrier=nil, api_key=nil)
      Address.validate_params(
        params[:street1],
        params[:city],
        params[:state],
        params[:zip],
        params[:country],
      )
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
        raise Error.new("Unable to verify address.")
      end
    end

    def verify(params={}, carrier=nil)
      Address.validate_params(
        self.street1,
        self.city,
        self.state,
        self.zip,
        self.country
      )

      begin
        response, api_key = EasyPost.request(:get, url + '/verify?carrier=' + String(carrier), @api_key, params)
      rescue
        raise Error.new("Unable to verify address.")
      end

      if response.has_key?(:address)
        return EasyPost::Util::convert_to_easypost_object(response[:address], api_key)
      else
        raise Error.new("Unable to verify address.")
      end

      return self
    end

    def self.validate_params(street1=nil, city=nil, state=nil, zip=nil, country=nil)
      errors = {}
      errors[:street1] = "can't be empty" unless street1
      errors[:city] = "can't be empty" unless zip
      errors[:state] = "can't be empty" unless zip
      errors[:zip] = "can't be empty" unless city && state
      errors[:country] = "can't be empty" unless country

      if errors.any?
        json_body = { error: { errors: errors } }
        raise Error.new("Unable to verify address.", nil, nil, json_body)
      end
    end
  end
end
