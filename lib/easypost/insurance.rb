# frozen_string_literal: true

# An Insurance object represents insurance for packages purchased both via the EasyPost API as well
# as shipments purchased through third parties and later registered with EasyPost.
class EasyPost::Insurance < EasyPost::Resource
  # Get the next page of insurances.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.insurances, page_size)
  end

  # Build the next page parameters.
  def self.build_next_page_params(_collection, current_page_items, page_size = nil)
    params = {}
    params[:before_id] = current_page_items.last.id
    unless page_size.nil?
      params[:page_size] = page_size
    end
    params
  end
end
