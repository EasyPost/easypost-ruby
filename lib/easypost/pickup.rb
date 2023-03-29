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

  # Get the lowest rate of a Pickup (can exclude by having `'!'` as the first element of your optional filter lists).
  def lowest_rate(carriers = [], services = [])
    EasyPost::Util.get_lowest_object_rate(self, carriers, services, 'pickup_rates')
  end

  # Get the next page of pickups.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.pickups, page_size)
  end

  # Build the next page parameters.
  def self.build_next_page_params(_collection, current_page_items, page_size = nil)
    params = {}
    params[:before_id] = current_page_items.last.id
    unless page_size.nil?
      params[:page_size] = page_size
    end
    params
  end
end
