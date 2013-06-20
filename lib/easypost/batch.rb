module EasyPost
  class Batch < Resource

    def self.create_and_buy(params={})
      wrapped_params = {}
      wrapped_params[self.class_name().to_sym] = params
      response, api_key = EasyPost.request(:post, url + '/create_and_buy', @api_key, wrapped_params)

      return Util.convert_to_easypost_object(response, api_key)
    end

    def label(params={})
      response, api_key = EasyPost.request(:post, url + '/label', @api_key, params)
      self.refresh_from(response, @api_key, true)
      
      return self
    end

    def remove_shipments(params={})
      response, api_key = EasyPost.request(:post, url + '/remove_shipments', @api_key, params)
      self.refresh_from(response, @api_key, true)
      
      return self
    end

    def add_shipments(params={})
      response, api_key = EasyPost.request(:post, url + '/add_shipments', @api_key, params)
      self.refresh_from(response, @api_key, true)
      
      return self
    end

  end
end
