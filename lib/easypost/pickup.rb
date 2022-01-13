# frozen_string_literal: true

class EasyPost::Pickup < EasyPost::Resource
  def buy(params = {})
    if params.instance_of?(EasyPost::PickupRate)
      temp = params.clone
      params = {}
      params[:carrier] = temp.carrier
      params[:service] = temp.service
    end

    response = EasyPost.make_request(:post, "#{url}/buy", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  def cancel(params = {})
    response = EasyPost.make_request(:post, "#{url}/cancel", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  def self.all(_filters = {}, _api_key = nil)
    raise NotImplementedError.new('Pickup.all not implemented.')
  end
end
