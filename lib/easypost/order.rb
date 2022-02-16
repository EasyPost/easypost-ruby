# frozen_string_literal: true

# The Order object represents a collection of packages and can be used for Multi-Piece Shipments.
class EasyPost::Order < EasyPost::Resource
  # Get the rates of an Order.
  def get_rates(params = {})
    response = EasyPost.make_request(:get, "#{url}/rates", @api_key, params)
    refresh_from(response, @api_key)

    self
  end

  # Buy an Order.
  def buy(params = {})
    if params.instance_of?(EasyPost::Rate)
      temp = params.clone
      params = {}
      params[:carrier] = temp.carrier
      params[:service] = temp.service
    end

    response = EasyPost.make_request(:post, "#{url}/buy", @api_key, params)
    refresh_from(response, @api_key)

    self
  end

  # Retrieve a list of Order objects.
  def self.all
    raise NotImplementedError.new('Order.all not implemented.')
  end
end
