module EasyPost
  class Address < Resource

    def verify(params={})
      response, api_key = EasyPost.request(:post, url + '/verify', @api_key, params)
      refresh_from(response, api_key)
      self
    end

  end
end
