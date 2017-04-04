module EasyPost
  class Report < Resource
    def self.create(params={}, api_key=nil)
      url = "#{self.url}/#{params[:type]}"
      wrapped_params = {}
      wrapped_params[class_name.to_sym] = params

      response, api_key = EasyPost.request(:post, url, api_key, params)
      return Util.convert_to_easypost_object(response, api_key)
    end

    def self.retrieve(params, api_key=nil)
      url = "#{self.url}/#{params[:type]}/#{params[:id]}"
      obj_id = params[:id].split("_")[0]

      response, api_key = EasyPost.request(:get, url, api_key, params)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end

    def self.all(filters={}, api_key=nil)
      url = "#{self.url}/#{filters[:type]}"

      response, api_key = EasyPost.request(:get, url, api_key, filters)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end
  end
end
