module EasyPost
  class Report < Resource
    def self.create(params={}, api_key=nil)
      url = self.url
      wrapped_params = {}
      wrapped_params[self.class_name().to_sym] = params
      report_types = ['shipment', 'payment_log', 'tracker']

      if report_types.include?(params[:type].to_s)
        url += "/#{params[:type]}"
      else
        raise Error.new("Undertermined Report Type")
      end
      response, api_key = EasyPost.request(:post, url, api_key, params)
      return Util.convert_to_easypost_object(response, api_key)
    end

    def self.retrieve(params={}, api_key=nil)
      url = self.url
      report_types = { shprep: 'shipment', plrep: 'payment_log', trkrep: 'tracker' }
      obj_id = params[:public_id].split("_")[0]
      if report_types.has_key?(obj_id.to_sym)
        url += "/#{report_types[obj_id.to_sym]}/#{params[:public_id]}"
      else
        raise Error.new("Undetermined Report Type")
      end
      response, api_key = EasyPost.request(:get, url, api_key, params)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end

    def self.all(filters={}, api_key=nil)
      url = self.url
      report_types = ['shipment', 'payment_log', 'tracker']

      if report_types.include?(filters[:type].to_s)
        url += "/#{filters[:type]}"
      else
        raise Error.new("Undertermined Report Type")
      end

      response, api_key = EasyPost.request(:get, url, api_key, filters)
      return EasyPost::Util::convert_to_easypost_object(response, api_key) if response
    end
  end
end
