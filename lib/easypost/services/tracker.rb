# frozen_string_literal: true

class EasyPost::Services::Tracker < EasyPost::Services::Service
  MODEL_CLASS = EasyPost::Models::Tracker

  # Create a Tracker
  def create(params = {})
    wrapped_params = { tracker: params }

    @client.make_request(:post, 'trackers', MODEL_CLASS, wrapped_params)
  end

  # Retrieve a Tracker
  def retrieve(id)
    @client.make_request(:get, "trackers/#{id}", MODEL_CLASS)
  end

  # Retrieve a list of Trackers
  def all(params)
    response = @client.make_request(:get, 'trackers', MODEL_CLASS, params)
    response.define_singleton_method(:tracking_code) { params[:tracking_code] }
    response.define_singleton_method(:carrier) { params[:carrier] }
    response
  end

  # Create multiple Tracker objects in bulk.
  def create_list(params = {})
    wrapped_params = { 'trackers' => params }

    @client.make_request(:post, 'trackers/create_list', MODEL_CLASS, wrapped_params)
    true # This endpoint does not return a response so we return true here instead
  end

  # Get the next page of trackers.
  def get_next_page(collection, page_size = nil)
    get_next_page_helper(collection, collection.trackers, 'trackers', MODEL_CLASS, page_size)
  end
end
