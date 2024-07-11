# frozen_string_literal: true

require 'set'

class EasyPost::Services::Shipment < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Shipment

  # Create a Shipment.
  def create(params = {})
    wrapped_params = { shipment: params }
    response = @client.make_request(:post, 'shipments', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a Shipment.
  def retrieve(id)
    response = @client.make_request(:get, "shipments/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a list of Shipments
  def all(params = {})
    filters = {
      key: 'shipments',
      purchased: params[:purchased],
      include_children: params[:include_children],
    }

    get_all_helper('shipments', MODEL_CLASS, params, filters)
  end

  # Get the next page of shipments.
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.shipments.last.id }
    params[:page_size] = page_size unless page_size.nil?
    params.merge!(collection[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).delete(:key)

    all(params)
  end

  # Regenerate the rates of a Shipment.
  def regenerate_rates(id)
    response = @client.make_request(:post, "shipments/#{id}/rerate")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Get the SmartRates of a Shipment.
  def get_smart_rates(id)
    response = @client.make_request(:get, "shipments/#{id}/smartrate")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS).result || []
  end

  # Buy a Shipment.
  def buy(id, params = {}, end_shipper_id = nil)
    if params.instance_of?(EasyPost::Models::Rate)
      params = { rate: params.clone }
    end

    params[:end_shipper_id] = end_shipper_id if end_shipper_id
    response = @client.make_request(:post, "shipments/#{id}/buy", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Insure a Shipment.
  def insure(id, params = {})
    params = { amount: params } if params.is_a?(Integer) || params.is_a?(Float)
    response = @client.make_request(:post, "shipments/#{id}/insure", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Refund a Shipment.
  def refund(id, params = {})
    response = @client.make_request(:post, "shipments/#{id}/refund", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Convert the label format of a Shipment.
  def label(id, params = {})
    params = { file_format: params } if params.is_a?(String)
    response = @client.make_request(:get, "shipments/#{id}/label", params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Get the lowest SmartRate of a Shipment.
  def lowest_smart_rate(id, delivery_days, delivery_accuracy)
    smart_rates = get_smart_rates(id)
    EasyPost::Util.get_lowest_smart_rate(smart_rates, delivery_days, delivery_accuracy)
  end

  # Generate a form for a Shipment.
  def generate_form(id, form_type, form_options = {})
    params = {}
    params[:type] = form_type
    merged_params = params.merge(form_options)
    wrapped_params = {
      form: merged_params,
    }
    response = @client.make_request(:post, "shipments/#{id}/forms", wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieves the estimated delivery date of each Rate via SmartRate.
  def retrieve_estimated_delivery_date(id, planned_ship_date)
    url = "shipments/#{id}/smartrate/delivery_date"
    params = { planned_ship_date: planned_ship_date }
    response = @client.make_request(:get, url, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS).rates
  end

  # Retrieve a recommended ship date for an existing Shipment via the Precision Shipping API, based on a specific desired delivery date.
  def recommend_ship_date(id, desired_delivery_date)
    url = "shipments/#{id}/smartrate/precision_shipping"
    params = { desired_delivery_date: desired_delivery_date }
    response = @client.make_request(:get, url, params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS).rates
  end
end
