# frozen_string_literal: true

class EasyPost::Batch < EasyPost::Resource
  def self.create_and_buy(params = {}, api_key = nil)
    wrapped_params = {}
    wrapped_params[class_name.to_sym] = params
    response = EasyPost.make_request(:post, "#{url}/create_and_buy", api_key, wrapped_params)

    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def buy(params = {})
    response = EasyPost.make_request(:post, "#{url}/buy", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  def label(params = {})
    response = EasyPost.make_request(:post, "#{url}/label", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  def remove_shipments(params = {})
    response = EasyPost.make_request(:post, "#{url}/remove_shipments", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  def add_shipments(params = {})
    response = EasyPost.make_request(:post, "#{url}/add_shipments", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  def create_scan_form(params = {})
    EasyPost.make_request(:post, "#{url}/scan_form", @api_key, params)
  end
end
