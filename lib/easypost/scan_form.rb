# frozen_string_literal: true

# A ScanForm can be created to speed up and simplify the carrier pickup process. The ScanForm is one document that can
# be scanned to mark all included tracking codes as "Accepted for Shipment" by the carrier.
class EasyPost::ScanForm < EasyPost::Resource
  # Create a ScanForm.
  def self.create(params = {}, api_key = nil)
    response = EasyPost.make_request(:post, url, api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  # Get the next page of scan forms.
  def self.get_next_page(collection, page_size = nil)
    get_next_page_exec(method(:all), collection, collection.scan_forms, page_size)
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
