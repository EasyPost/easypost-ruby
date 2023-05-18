# frozen_string_literal: true

class EasyPost::Services::Pickup < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Pickup

  # Create a Pickup object
  def create(params = {})
    wrapped_params = { pickup: params }
    @client.make_request(:post, 'pickups', MODEL_CLASS, wrapped_params)
  end

  # Retrieve a Pickup object
  def retrieve(id)
    @client.make_request(:get, "pickups/#{id}", MODEL_CLASS)
  end

  # Retrieve all Pickup objects
  def all(params = {})
    @client.make_request(:get, 'pickups', MODEL_CLASS, params)
  end

  # Buy a Pickup
  def buy(id, params = {})
    if params.instance_of?(EasyPost::Models::PickupRate)
      params = { carrier: params[:carrier], service: params[:service] }
    end

    @client.make_request(:post, "pickups/#{id}/buy", MODEL_CLASS, params)
  end

  # Cancel a Pickup
  def cancel(id, params = {})
    @client.make_request(:post, "pickups/#{id}/cancel", MODEL_CLASS, params)
  end

  # Get next page of Pickups
  def get_next_page(collection, page_size = nil)
    get_next_page_helper(collection, collection.pickups, 'pickups', MODEL_CLASS, page_size)
  end
end
