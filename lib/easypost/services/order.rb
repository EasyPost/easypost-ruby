# frozen_string_literal: true

class EasyPost::Services::Order < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Order

  # Create an Order object
  def create(params = {})
    wrapped_params = { order: params }
    response = @client.make_request(:post, 'orders', MODEL_CLASS, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve an Order object
  def retrieve(id)
    response = @client.make_request(:get, "orders/#{id}", MODEL_CLASS)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve new rates for an Order object
  def get_rates(id, params = {})
    response = @client.make_request(:get, "orders/#{id}/rates", MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Buy an Order object
  def buy(id, params = {})
    if params.instance_of?(EasyPost::Models::Rate)
      params = { carrier: params[:carrier], service: params[:service] }
    end

    response = @client.make_request(:post, "orders/#{id}/buy", MODEL_CLASS, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
