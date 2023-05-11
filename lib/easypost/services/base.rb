# frozen_string_literal: true

# The base class for all services in the library.
class EasyPost::Services::Service
  def initialize(client)
    @client = client
  end

  protected

  def get_next_page_exec(collection, current_page_items, endpoint, cls, page_size = nil)
    has_more = collection.has_more || false
    unless !has_more || current_page_items.nil? || current_page_items.empty?
      params = {}
      params[:before_id] = current_page_items.last.id
      unless page_size.nil?
        params[:page_size] = page_size
      end

      @client.make_request(:get, endpoint, cls, params)
    end

    # issue with getting the next page
    raise EasyPost::Error.new('There are no more pages to retrieve.')
  end
end
