module EasyPost
  print("module loaded")
  class Order < Resource
     print("I'm being loaded")
    def get_rates(params={})
      response, api_key = EasyPost.request(:get, url + '/rates', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end

    def buy(params={})
      if params.instance_of?(EasyPost::Rate)
        temp = params.clone
        params = {}
        params[:carrier] = temp.carrier
        params[:service] = temp.service
      end

      response, api_key = EasyPost.request(:post, url + '/buy', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end

    def hello_world
      print("in here\n")
      return self
    end

    def lowest_rate(carriers=[], services=[])
      lowest = nil

      self.get_rates unless self.rates

      carriers = carriers.is_a?(String) ? carriers.split(',') : Array(carriers)
      carriers.map!(&:downcase)
      carriers.map!(&:strip)

      negative_carriers = []
      carriers_copy = carriers.clone
      carriers_copy.each do |carrier|
        if carrier[0,1] == '!'
          negative_carriers << carrier[1..-1]
          carriers.delete(carrier)
        end
      end

      services = services.is_a?(String) ? services.split(',') : Array(services)
      services.map!(&:downcase)
      services.map!(&:strip)

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

      raise Error.new('No rates found.') if lowest == nil

      return lowest
    end

  end
end

  end
end
