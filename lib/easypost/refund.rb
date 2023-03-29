# frozen_string_literal: true

# The Refund object contains details about the Refund of a Shipment.
class EasyPost::Refund < EasyPost::Resource
  # Get the next page of refunds.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.refunds, page_size)
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
