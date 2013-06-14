module EasyPost
  class Shipment < Resource

    def get_rates(params={})
      response, api_key = EasyPost.request(:get, url + '/rates', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end

    def buy(params={})
      response, api_key = EasyPost.request(:post, url + '/buy', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end

    def refund(params={})
      response, api_key = EasyPost.request(:get, url + '/refund', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end

    def track(params={})
      response, api_key = EasyPost.request(:get, url + '/track', @api_key, params)
      self.refresh_from(response, @api_key, true)

      return self
    end

    def stamp(params={})
      response, api_key = EasyPost.request(:get, url + '/stamp', @api_key, params)

      return response[:stamp_url]
    end

    def barcode(params={})
      response, api_key = EasyPost.request(:get, url + '/barcode', @api_key, params)

      return response[:barcode_url]
    end

    def lowest_rate(carriers=[], services=[])
      lowest = nil

      self.get_rates unless self.rates
      
      if !carriers.is_a?(Array)
        carriers = carriers.split(',')
      end
      carriers.map!(&:downcase)

      if !services.is_a?(Array)
        services = services.split(',')
      end
      services.map!(&:downcase)

      self.rates.each do |k|

        rate_carrier = k.carrier.downcase
        if carriers.size() > 0 && !carriers.include?(rate_carrier)
          next
        end

        rate_service = k.service.downcase
        if services.size() > 0 && !services.include?(rate_service)
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
