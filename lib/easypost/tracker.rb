class EasyPost::Tracker < EasyPost::Resource
  def self.create_list(params={}, api_key=nil)
    url = self.url + '/create_list'
    response = EasyPost.make_request(:post, url, api_key, params)
    return true
  end
end
