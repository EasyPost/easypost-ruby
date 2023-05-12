# frozen_string_literal: true

# The Order service represents a collection of packages and can be used for Multi-Piece Shipments.
class EasyPost::Services::Order < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Order

  # Create an Order object
  def create(params = {})
    wrapped_params = { order: params }
    @client.make_request(:post, 'orders', MODEL_CLASS, wrapped_params)
  end

  # Retrieve an Order object
  def retrieve(id)
    @client.make_request(:get, "orders/#{id}", MODEL_CLASS)
  end

  # Retrieve new rates for an Order object
  def get_rates(id, params = {})
    @client.make_request(:get, "orders/#{id}/rates", MODEL_CLASS, params)
  end

  # Buy an Order object
  def buy(id, params = {})
    if params.instance_of?(EasyPost::Models::Rate)
      params = { carrier: params[:carrier], service: params[:service] }
    end

    @client.make_request(:post, "orders/#{id}/buy", MODEL_CLASS, params)
  end
end
