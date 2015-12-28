module EasyPost
  class Tracker < Resource
    def self.create_list(params={}, api_key=nil)
      url = self.url + '/create_list'
      response, api_key = EasyPost.request(:post, url, api_key, params)
      return true
    end

    def self.all_updated(params={}, api_key=nil)
      url = self.url + '/all_updated'
      response, api_key = EasyPost.request(:get, url, api_key, params)
      return Util.convert_to_easypost_object(response, api_key)
    end
  end
end
