module EasyPost
  class Pickup < Resource

    def buy(params={})
      if params.instance_of?(EasyPost::PickupRate)
        temp = params.clone
        params = {}
        params[:carrier] = temp.carrier
        params[:service] = temp.service
      end

      response = EasyPost.make_request(:post, url + '/buy', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end

    def cancel(params={})
      response = EasyPost.make_request(:post, url + '/cancel', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end
  end
end
