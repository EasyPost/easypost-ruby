class EasyPost::Shipment < EasyPost::Resource
  def get_rates(params={})
    response = EasyPost.make_request(:get, url + '/rates', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def buy(params={})
    if params.instance_of?(EasyPost::Rate)
      temp = params.clone
      params = {}
      params[:rate] = temp
    end

    response = EasyPost.make_request(:post, url + '/buy', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def insure(params={})
    if params.is_a?(Integer) || params.is_a?(Float)
      temp = params.clone
      params = {}
      params[:amount] = temp
    end

    response = EasyPost.make_request(:post, url + '/insure', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def refund(params={})
    response = EasyPost.make_request(:get, url + '/refund', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def print(params={})
    if params.instance_of?(EasyPost::Printer)
      return params.print(self.postage_label)
    end
    return false
  end

  def label(params={})
    if params.is_a?(String)
      temp = params.clone
      params = {}
      params[:file_format] = temp
    end

    response = EasyPost.make_request(:get, url + '/label', @api_key, params)
    self.refresh_from(response, @api_key, true)

    return self
  end

  def lowest_rate(carriers=[], services=[])
    lowest = nil

    self.get_rates unless self.rates

    carriers = EasyPost::Util.normalize_string_list(carriers)

    negative_carriers = []
    carriers_copy = carriers.clone
    carriers_copy.each do |carrier|
      if carrier[0,1] == '!'
        negative_carriers << carrier[1..-1]
        carriers.delete(carrier)
      end
    end

    services = EasyPost::Util.normalize_string_list(services)

    negative_services = []
    services_copy = services.clone
    services_copy.each do |service|
      if service[0,1] == '!'
        negative_services << service[1..-1]
        services.delete(service)
      end
    end

    self.rates.each do |k|

      rate_carrier = k.carrier.downcase
      if carriers.size() > 0 && !carriers.include?(rate_carrier)
        next
      end
      if negative_carriers.size() > 0 && negative_carriers.include?(rate_carrier)
        next
      end

      rate_service = k.service.downcase
      if services.size() > 0 && !services.include?(rate_service)
        next
      end
      if negative_services.size() > 0 && negative_services.include?(rate_service)
        next
      end

      if lowest == nil || k.rate.to_f < lowest.rate.to_f
          lowest = k
      end
    end

    raise EasyPost::Error.new('No rates found.') if lowest == nil

    return lowest
  end
end
