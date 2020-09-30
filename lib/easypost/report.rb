class EasyPost::Report < EasyPost::Resource
  def self.create(params={}, api_key=nil)
    url = "#{self.url}/#{params[:type]}"
    wrapped_params = {}
    wrapped_params[class_name.to_sym] = params

    response = EasyPost.make_request(:post, url, api_key, params)
    return EasyPost::Util.convert_to_easypost_object(response, api_key)
  end

  def self.retrieve(params, api_key=nil)
    id = if params.is_a?(String)
      params
    else
      params[:id]
    end

    instance = self.new(id, api_key)
    instance.refresh
    return instance
  end

  def self.all(filters={}, api_key=nil)
    url = "#{self.url}/#{filters[:type]}"

    response = EasyPost.make_request(:get, url, api_key, filters)
    return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
  end
end
