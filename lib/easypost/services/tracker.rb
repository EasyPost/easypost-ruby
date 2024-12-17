# frozen_string_literal: true

class EasyPost::Services::Tracker < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Tracker #:nodoc:

  # Create a Tracker
  def create(params = {})
    wrapped_params = { tracker: params }
    response = @client.make_request(:post, 'trackers', wrapped_params)

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a Tracker
  def retrieve(id)
    response = @client.make_request(:get, "trackers/#{id}")

    EasyPost::InternalUtilities::Json.convert_json_to_object(response, MODEL_CLASS)
  end

  # Retrieve a list of Trackers
  def all(params = {})
    filters = {
      key: 'trackers',
      tracking_code: params[:tracking_code],
      carrier: params[:carrier],
    }

    get_all_helper('trackers', MODEL_CLASS, params, filters)
  end

  # Get the next page of trackers.
  def get_next_page(collection, page_size = nil)
    raise EasyPost::Errors::EndOfPaginationError.new unless more_pages?(collection)

    params = { before_id: collection.trackers.last.id }
    params[:page_size] = page_size unless page_size.nil?
    params.merge!(collection[EasyPost::InternalUtilities::Constants::FILTERS_KEY]).delete(:key)

    all(params)
  end
end
