# frozen_string_literal: true

# A Report contains a csv that is a log of all the objects created within a certain time frame.
class EasyPost::Report < EasyPost::Resource
  # Create a Report.
  def self.create(params = {}, api_key = nil)
    url = "#{self.url}/#{params[:type]}"

    wrapped_params = {}
    wrapped_params[class_name.to_sym] = params

    response = EasyPost.make_request(:post, url, api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Retrieve a list of Report objects.
  def self.all(filters = {}, api_key = nil)
    url = "#{self.url}/#{filters[:type]}"

    response = EasyPost.make_request(:get, url, api_key, filters)
    collection = EasyPost::Util.convert_to_easypost_object(response, api_key)

    # Store the filters used to retrieve the collection.
    collection.refresh_from({ type: filters[:type] }, api_key)

    collection
  end

  # Get the next page of addresses.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.reports, page_size)
  end

  # Build the next page parameters.
  def self.build_next_page_params(collection, current_page_items, page_size = nil)
    params = {}
    params[:before_id] = current_page_items.last.id
    unless page_size.nil?
      params[:page_size] = page_size
    end
    params[:type] = collection.type
    params
  end
end
