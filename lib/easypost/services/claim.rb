# frozen_string_literal: true

class EasyPost::Services::Claim < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Claim

  # Create an Claim object
  def create(params = {})
    response = @client.make_request(:post, 'claims', params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve an Claim object
  def retrieve(id)
    response = @client.make_request(:get, "claims/#{id}", nil)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve all Claim objects
  def all(params = {})
    filters = { key: 'claims' }

    get_all_helper('claims', MODEL_CLASS, params, filters)
  end

  # Get the next page of claims.
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.claims.last.id }
    params[:page_size] = page_size unless page_size.nil?

    all(params)
  end

  # Cancel a filed claim
  def cancel(id)
    response = @client.make_request(:post, "claims/#{id}/cancel", nil)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end
end
