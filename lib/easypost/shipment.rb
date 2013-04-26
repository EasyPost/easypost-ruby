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

    def lowest_rate
      lowest = nil
      begin
        self.get_rates unless self.rates
          
        self.rates.each do |k|
          if lowest == nil or k.rate.to_f < lowest.rate.to_f
            lowest = k
          end
        end
      rescue Exception => e
        raise Error.new('Error determining lowest rate.')
      end
      return lowest
    end

  end
end
