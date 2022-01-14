# frozen_string_literal: true

class EasyPost::ScanForm < EasyPost::Resource
  def self.create(params = {}, api_key = nil)
    response = EasyPost.make_request(:post, url, api_key, params)
    EasyPost::Util.convert_to_easypost_object(response, api_key)
  end
end
