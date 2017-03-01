module EasyPost
  class Report < Resource
    REPORT_TYPES = { shprep: 'shipment', plrep: 'payment_log', trkrep: 'tracker' }

    def self.create(params={}, api_key=nil)
      url = self.url
      wrapped_params = {}
      wrapped_params[class_name.to_sym] = params

      if REPORT_TYPES.values.include?(params[:type].to_s)
        url += "/#{params[:type]}"
      else
        raise Error.new("Undetermined Report Type")
      end

      response, api_key = EasyPost.request(:post, url, api_key, params)
      return Util.convert_to_easypost_object(response, api_key)
    end

    def self.retrieve(params, api_key=nil)
      url = self.url
      obj_id = params[:id].split("_")[0]

      if REPORT_TYPES.has_key?(obj_id.to_sym)
        url += "/#{REPORT_TYPES[obj_id.to_sym]}/#{params[:id]}"
      else
        raise Error.new("Undetermined Report Type")
      end

      response, api_key = EasyPost.request(:get, url, api_key, params)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end

    def self.all(filters={}, api_key=nil)
      url = self.url

      if REPORT_TYPES.values.include?(filters[:type].to_s)
        url += "/#{filters[:type]}"
      else
        raise Error.new("Undetermined Report Type")
      end

      response, api_key = EasyPost.request(:get, url, api_key, filters)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end
  end
end
