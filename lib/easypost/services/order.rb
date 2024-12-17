# frozen_string_literal: true

class EasyPost::Services::Order < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Order # :nodoc:

  # Create an Order object
  def create(params = {})
    wrapped_params = { order: params }
    response = @client.make_request(:post, 'orders', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve an Order object
  def retrieve(id)
    response = @client.make_request(:get, "orders/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve new rates for an Order object
  def get_rates(id, params = {})
    response = @client.make_request(:get, "orders/#{id}/rates", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Buy an Order object
  def buy(id, params = {})
    if params.instance_of?(EasyPost::Models::Rate)
      params = { carrier: params[:carrier], service: params[:service] }
    end

    response = @client.make_request(:post, "orders/#{id}/buy", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
