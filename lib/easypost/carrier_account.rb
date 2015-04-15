module EasyPost
  class CarrierAccount < Resource
    def save
      values = {}

      if @unsaved_values.length > 0
        @unsaved_values.each { |k| values[k] = @values[k] }
      end

      unless self.credentials.nil? or @unsaved_values.include?(:credentials)
        if self.credentials.unsaved_values.length > 0
          values[:credentials] = {}
          self.credentials.unsaved_values.each do |k|
            values[:credentials][k] = @values[:credentials][k]
          end
        end
      end

      unless self.test_credentials.nil? or @unsaved_values.include?(:test_credentials)
        if self.test_credentials.unsaved_values.length > 0
          values[:test_credentials] = {}
          self.test_credentials.unsaved_values.each do |k|
            values[:test_credentials][k] = @values[:test_credentials][k]
          end
        end
      end

      if values.length > 0
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
