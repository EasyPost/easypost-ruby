module EasyPost
  class Report < Resource
    REPORT_TYPES = ['shipment', 'payment_log', 'tracker']

    def self.create(params={}, api_key=nil)
      url = self.url
      wrapped_params = {}
      wrapped_params[class_name.to_sym] = params

      if REPORT_TYPES.include?(params[:type].to_s)
        url += "/#{params[:type]}"
      else
        raise Error.new("Undetermined Report Type")
      end
      response, api_key = EasyPost.request(:post, url, api_key, params)
      return Util.convert_to_easypost_object(response, api_key)
    end

    def self.retrieve(params, api_key=nil)
      url = self.url
      report_types_hash = { shprep: 'shipment', plrep: 'payment_log', trkrep: 'tracker' }
      obj_id = params[:id].split("_")[0]
      if report_types_hash.has_key?(obj_id.to_sym)
        url += "/#{report_types_hash[obj_id.to_sym]}/#{params[:id]}"
      else
        raise Error.new("Undetermined Report Type")
      end
      response, api_key = EasyPost.request(:get, url, api_key, params)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end

    def self.all(filters={}, api_key=nil)
      url = self.url

      if REPORT_TYPES.include?(filters[:type].to_s)
        url += "/#{filters[:type]}"
      else
        raise Error.new("Undetermined Report Type")
      end

      response, api_key = EasyPost.request(:get, url, api_key, filters)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end
  end
end
