module EasyPost
  class Order < Resource

    def buy(params={})
      if params.instance_of?(EasyPost::Rate)
        temp = params.clone
        params = {}
        params[:carrier] = temp.carrier
        params[:service] = temp.service
      end

      response, api_key = EasyPost.request(:post, url + '/buy', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end

  end
end
