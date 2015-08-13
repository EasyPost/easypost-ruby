module EasyPost
  class Item < Resource

    def self.retrieve_reference(params={}, api_key=nil)
      response, api_key = EasyPost.request(:get, url + '/retrieve_reference', api_key, params)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end

  end
end
