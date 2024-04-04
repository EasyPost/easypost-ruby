# frozen_string_literal: true

class EasyPost::Services::Insurance < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Insurance

  # Create an Insurance object
  def create(params = {})
    wrapped_params = { insurance: params }
    response = @client.make_request(:post, 'insurances', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve an Insurance object
  def retrieve(id)
    response = @client.make_request(:get, "insurances/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all Insurance objects
  def all(params = {})
    filters = { key: 'insurances' }

    get_all_helper('insurances', MODEL_CLASS, params, filters)
  end

  # Get the next page of insurances.
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.insurances.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end

  # Refund an Insurance object
  def refund(id)
    response = @client.make_request(:post, "insurances/#{id}/refund")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
