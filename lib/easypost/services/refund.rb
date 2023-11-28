# frozen_string_literal: true

class EasyPost::Services::Refund < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Refund

  # Create a Refund object
  def create(params = {})
    wrapped_params = { refund: params }
    response = @client.make_request(:post, 'refunds', MODEL_CLASS, wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a Refund object
  def retrieve(id)
    response = @client.make_request(:get, "refunds/#{id}", MODEL_CLASS)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all Refund objects
  def all(params = {})
    filters = { 'key' => 'refunds' }

    get_all_helper('refunds', MODEL_CLASS, params, filters)
  end

  # Get the next page of refunds
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless

    params = { before_id: collection.refunds.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end
end
