# frozen_string_literal: true

class EasyPost::Tracker < EasyPost::Resource
  def self.create_list(params = {}, api_key = nil)
    url = "#{self.url}/create_list"
    newParams = { "trackers" => params }
    EasyPost.make_request(:post, url, api_key, newParams)
    true # This endpoint does not return a response so we return true here instead
  end
end
