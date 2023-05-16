# frozen_string_literal: true

# The Refund service contains details about the Refund of a Shipment.
class EasyPost::Services::Report < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Report

  # Create a Report
  def create(params = {})
    unless params[:type]
      raise ArgumentError, "Missing 'type' parameter in params" # TODO: replace the error in the error-handling overhaul PR
    end

    type = params.delete(:type)
    url = "reports/#{type}"

    @client.make_request(:post, url, MODEL_CLASS, params)
  end

  # Retrieve a Report
  def retrieve(id)
    @client.make_request(:get, "reports/#{id}", MODEL_CLASS)
  end

  # Retrieve all Report objects
  def all(params = {})
    unless params[:type]
      raise ArgumentError, "Missing 'type' parameter in params" # TODO: replace the error in the error-handling overhaul PR
    end

    type = params.delete(:type)
    url = "reports/#{type}"

    response = @client.make_request(:get, url, MODEL_CLASS, params)
    response.define_singleton_method(:type) { type }
    response
  end

  # Get next page of Report objects
  def get_next_page(collection, page_size = nil)
    url = "reports/#{collection.type}"
    get_next_page_helper(collection, collection.reports, url, MODEL_CLASS, page_size)
  end
end
