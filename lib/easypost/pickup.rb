# frozen_string_literal: true

# The Pickup object allows you to schedule a pickup from your carrier from your customer's residence or place of business.
class EasyPost::Pickup < EasyPost::Resource
  # Buy a Pickup.
  def buy(params = {})
    if params.instance_of?(EasyPost::PickupRate)
      temp = params.clone
      params = {}
      params[:carrier] = temp.carrier
      params[:service] = temp.service
    end

    response = EasyPost.make_request(:post, "#{url}/buy", @api_key, params)
    refresh_from(response, @api_key)

    self
  end

  # Cancel a Pickup.
  def cancel(params = {})
    response = EasyPost.make_request(:post, "#{url}/cancel", @api_key, params)
    refresh_from(response, @api_key)

    self
  end

  # Retrieve a list of all Pickup objects.
  def self.all(filters = {}, api_key = nil)
    raise NotImplementedError.new('Pickup.all not implemented.')
  end

  # Get the lowest rate of a Pickup (can exclude by having `'!'` as the first element of your optional filter lists).
  def lowest_rate(carriers = [], services = [])
    EasyPost::Util.get_lowest_object_rate(self, carriers, services, 'pickup_rates')
  end
end
