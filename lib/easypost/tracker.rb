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
end
