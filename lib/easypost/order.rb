class EasyPost::Order < EasyPost::Resource

  def get_rates(params={})
    response = EasyPost.make_request(:get, url + '/rates', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def buy(params={})
    if params.instance_of?(EasyPost::Rate)
      temp = params.clone
      params = {}
      params[:carrier] = temp.carrier
      params[:service] = temp.service
    end

    response = EasyPost.make_request(:post, url + '/buy', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def self.all(filters={}, api_key=nil)
    raise NotImplementedError.new('Order.all not implemented.')
  end

end
