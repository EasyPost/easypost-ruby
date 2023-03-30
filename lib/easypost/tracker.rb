# frozen_string_literal: true

# A Tracker object contains all of the tracking information for a package.
class EasyPost::Tracker < EasyPost::Resource
  # Create multiple Tracker objects in bulk.
  def self.create_list(params = {}, api_key = nil)
    url = "#{self.url}/create_list"
    new_params = { 'trackers' => params }
    EasyPost.make_request(:post, url, api_key, new_params)
    true # This endpoint does not return a response so we return true here instead
  end

  # Retrieve a list of Tracker objects.
  def self.all(filters = {}, api_key = nil)
    collection = super(filters, api_key)

    # Store the filters used to retrieve the collection.
    collection.refresh_from({ tracking_code: filters[:tracking_code], carrier: filters[:carrier] }, api_key)

    collection
  end

  # Get the next page of trackers.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.trackers, page_size)
  end

  # Build the next page parameters.
  def self.build_next_page_params(collection, current_page_items, page_size = nil)
    params = {}
    params[:before_id] = current_page_items.last.id
    unless page_size.nil?
      params[:page_size] = page_size
    end
    unless collection.tracking_code.nil?
      params[:tracking_code] = collection.tracking_code
    end
    unless collection.carrier.nil?
      params[:carrier] = collection.carrier
    end
    params
  end
end
