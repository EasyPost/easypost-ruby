class EasyPost::ScanForm < EasyPost::Resource
  def self.create(params={}, api_key=nil)
    response = EasyPost.make_request(:post, self.url, api_key, params)
    return EasyPost::Util.convert_to_easypost_object(response, api_key)
  end
end
