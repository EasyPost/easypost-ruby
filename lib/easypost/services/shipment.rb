# frozen_string_literal: true

require 'set'

# The workhorse of the EasyPost API, a Shipment is made up of a "to" and "from" Address, the Parcel
# being shipped, and any customs forms required for international deliveries.
class EasyPost::Services::Shipment < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Shipment

  # Create a Shipment.
  def create(params = {}, with_carbon_offset = false)
    wrapped_params = {
      shipment: params,
      carbon_offset: with_carbon_offset,
    }

    @client.make_request(:post, 'shipments', MODEL_CLASS, wrapped_params)
  end

  # Retrieve a Shipment.
  def retrieve(id)
    @client.make_request(:get, "shipments/#{id}", MODEL_CLASS)
  end

  # Retrieve a list of Shipments
  def all(params = {})
    response = @client.make_request(:get, 'shipments', MODEL_CLASS, params)
    response.define_singleton_method(:purchased) { params[:purchased] }
    response.define_singleton_method(:include_children) { params[:include_children] }
    response
  end

  # Get the next page of shipments.
  def get_next_page(collection, page_size = nil)
    get_next_page_helper(collection, collection.shipments, 'shipments', MODEL_CLASS, page_size)
  end

  # Regenerate the rates of a Shipment.
  def regenerate_rates(id, with_carbon_offset = false)
    params = { carbon_offset: with_carbon_offset }

    @client.make_request(:post, "shipments/#{id}/rerate", MODEL_CLASS, params)
  end

  # Get the SmartRates of a Shipment.
  def get_smartrates(id)
    @client.make_request(:get, "shipments/#{id}/smartrate", MODEL_CLASS).result || []
  end

  # Buy a Shipment.
  def buy(id, params = {}, with_carbon_offset = false, end_shipper_id = nil)
    if params.instance_of?(EasyPost::Models::Rate)
      params = { rate: params.clone }
    end

    params[:carbon_offset] = params[:with_carbon_offset] || with_carbon_offset
    params.delete(:with_carbon_offset)

    params[:end_shipper_id] = end_shipper_id if end_shipper_id

    @client.make_request(:post, "shipments/#{id}/buy", MODEL_CLASS, params)
  end

  # Insure a Shipment.
  def insure(id, params = {})
    params = { amount: params } if params.is_a?(Integer) || params.is_a?(Float)

    @client.make_request(:post, "shipments/#{id}/insure", MODEL_CLASS, params)
  end

  # Refund a Shipment.
  def refund(id, params = {})
    @client.make_request(:post, "shipments/#{id}/refund", MODEL_CLASS, params)
  end

  # Convert the label format of a Shipment.
  def label(id, params = {})
    params = { file_format: params } if params.is_a?(String)

    @client.make_request(:get, "shipments/#{id}/label", MODEL_CLASS, params)
  end

  # Get the lowest smartrate of a Shipment.
  def lowest_smartrate(id, delivery_days, delivery_accuracy)
    smartrates = get_smartrates(id)
    EasyPost::Util.get_lowest_smartrate(smartrates, delivery_days, delivery_accuracy)
  end

  # Generate a form for a Shipment.
  def generate_form(id, form_type, form_options = {})
    params = {}
    params[:type] = form_type
    merged_params = params.merge(form_options)
    wrapped_params = {
      form: merged_params,
    }

    @client.make_request(:post, "shipments/#{id}/forms", MODEL_CLASS, wrapped_params)
  end

  # Retrieves the estimated delivery date of each Rate via SmartRate.
  def retrieve_estimated_delivery_date(id, planned_ship_date)
    url = "shipments/#{id}/smartrate/delivery_date"
    params = { planned_ship_date: planned_ship_date }

    @client.make_request(:get, url, MODEL_CLASS, params).rates
  end
end
