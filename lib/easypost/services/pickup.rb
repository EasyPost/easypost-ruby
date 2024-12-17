# frozen_string_literal: true

class EasyPost::Services::Pickup < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Pickup #:nodoc:

  # Create a Pickup object
  def create(params = {})
    wrapped_params = { pickup: params }
    response = @client.make_request(:post, 'pickups', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a Pickup object
  def retrieve(id)
    response = @client.make_request(:get, "pickups/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all Pickup objects
  def all(params = {})
    filters = { key: 'pickups' }

    get_all_helper('pickups', MODEL_CLASS, params, filters)
  end

  # Buy a Pickup
  def buy(id, params = {})
    if params.instance_of?(EasyPost::Models::PickupRate)
      params = { carrier: params[:carrier], service: params[:service] }
    end

    response = @client.make_request(:post, "pickups/#{id}/buy", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Cancel a Pickup
  def cancel(id, params = {})
    response = @client.make_request(:post, "pickups/#{id}/cancel", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Get next page of Pickups
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.pickups.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end
end
