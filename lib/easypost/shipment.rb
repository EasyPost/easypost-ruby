# frozen_string_literal: true

# The workhorse of the EasyPost API, a Shipment is made up of a "to" and "from" Address, the Parcel
# being shipped, and any customs forms required for international deliveries.
class EasyPost::Shipment < EasyPost::Resource
  # Regenerate the rates of a Shipment.
  def regenerate_rates(params = {})
    response = EasyPost.make_request(:post, "#{url}/rerate", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  # Get the SmartRates of a Shipment.
  def get_smartrates # rubocop:disable Naming/AccessorMethodName
    response = EasyPost.make_request(:get, "#{url}/smartrate", @api_key)

    response.fetch('result', [])
  end

  # Buy a Shipment.
  def buy(params = {})
    if params.instance_of?(EasyPost::Rate)
      temp = params.clone
      params = {}
      params[:rate] = temp
    end

    response = EasyPost.make_request(:post, "#{url}/buy", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  # Insure a Shipment.
  def insure(params = {})
    if params.is_a?(Integer) || params.is_a?(Float)
      temp = params.clone
      params = {}
      params[:amount] = temp
    end

    response = EasyPost.make_request(:post, "#{url}/insure", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  # Refund a Shipment.
  def refund(params = {})
    response = EasyPost.make_request(:get, "#{url}/refund", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  # Conver the label format of a Shipment.
  def label(params = {})
    if params.is_a?(String)
      temp = params.clone
      params = {}
      params[:file_format] = temp
    end

    response = EasyPost.make_request(:get, "#{url}/label", @api_key, params)
    refresh_from(response, @api_key, true)

    self
  end

  # Get the lowest rate of a Shipment.
  def lowest_rate(carriers = [], services = [])
    lowest = nil

    get_rates unless rates

    carriers = EasyPost::Util.normalize_string_list(carriers)

    negative_carriers = []
    carriers_copy = carriers.clone
    carriers_copy.each do |carrier|
      if carrier[0, 1] == '!'
        negative_carriers << carrier[1..-1]
        carriers.delete(carrier)
      end
    end

    services = EasyPost::Util.normalize_string_list(services)

    negative_services = []
    services_copy = services.clone
    services_copy.each do |service|
      if service[0, 1] == '!'
        negative_services << service[1..-1]
        services.delete(service)
      end
    end

    rates.each do |k|
      rate_carrier = k.carrier.downcase
      if carriers.size.positive? && !carriers.include?(rate_carrier)
        next
      end
      if negative_carriers.size.positive? && negative_carriers.include?(rate_carrier)
        next
      end

      rate_service = k.service.downcase
      if services.size.positive? && !services.include?(rate_service)
        next
      end
      if negative_services.size.positive? && negative_services.include?(rate_service)
        next
      end

      if lowest.nil? || k.rate.to_f < lowest.rate.to_f
        lowest = k
      end
    end

    raise EasyPost::Error.new('No rates found.') if lowest.nil?

    lowest
  end
end
