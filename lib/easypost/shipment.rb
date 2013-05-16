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

    def lowest_rate(carriers='')
      lowest = nil

      begin
        self.get_rates unless self.rates
          
        self.rates.each do |k|
          if lowest == nil or k.rate.to_f < lowest.rate.to_f
            if carriers
              if carriers.is_a?(Array)
                if carriers.include?(k.carrier)
                  lowest = k
                end
              else
                if carriers = k.carrier
                  lowest = k
                end
              end
            else
              lowest = k
            end
          end
        end
      rescue
        raise Error.new('Error determining lowest rate.')
      end
      return lowest
    end

    def stamp(params={})
      response, api_key = EasyPost.request(:get, url + '/stamp', @api_key, params)
      return response[:stamp_url]
    end

    def barcode(params={})
      response, api_key = EasyPost.request(:get, url + '/barcode', @api_key, params)
      return response[:barcode_url]
    end
  end
end
