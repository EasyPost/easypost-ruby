# frozen_string_literal: true

# A ScanForm can be created to speed up and simplify the carrier pickup process. The ScanForm is one document that can
# be scanned to mark all included tracking codes as "Accepted for Shipment" by the carrier.
class EasyPost::ScanForm < EasyPost::Resource
  # Create a ScanForm.
  def self.create(params = {}, api_key = nil)
    response = EasyPost.make_request(:post, url, api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end
end
