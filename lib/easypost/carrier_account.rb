module EasyPost
  class CarrierAccount < Resource
    def save
      if @unsaved_values.length > 0
        values = {}
        @unsaved_values.each { |k| values[k] = @values[k] }

        wrapped_params = {carrier_account: values}

        response, api_key = EasyPost.request(:put, url, @api_key, wrapped_params)
        refresh_from(response, api_key)
      end
      return self
    end

    def self.types
      response, api_key = EasyPost.request(:get, "/carrier_types", @api_key)
      return Util.convert_to_easypost_object(response, api_key)
    end
  end
end
