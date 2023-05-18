# frozen_string_literal: true

# Client Library helper functions
module EasyPost::Util
  # Gets the lowest rate of an EasyPost object such as a Shipment, Order, or Pickup.
  # You can exclude by having `'!'` as the first element of your optional filter lists
  def self.get_lowest_object_rate(easypost_object, carriers = [], services = [], rates_key = 'rates')
    lowest_rate = nil

    carriers = EasyPost::InternalUtilities.normalize_string_list(carriers)
    negative_carriers = []
    carriers_copy = carriers.clone
    carriers_copy.each do |carrier|
      if carrier[0, 1] == '!'
        negative_carriers << carrier[1..]
        carriers.delete(carrier)
      end
    end

    services = EasyPost::InternalUtilities.normalize_string_list(services)
    negative_services = []
    services_copy = services.clone
    services_copy.each do |service|
      if service[0, 1] == '!'
        negative_services << service[1..]
        services.delete(service)
      end
    end

    easypost_object.send(rates_key).each do |rate|
      rate_carrier = rate.carrier.downcase
      if carriers.size.positive? && !carriers.include?(rate_carrier)
        next
      end
      if negative_carriers.size.positive? && negative_carriers.include?(rate_carrier)
        next
      end

      rate_service = rate.service.downcase
      if services.size.positive? && !services.include?(rate_service)
        next
      end
      if negative_services.size.positive? && negative_services.include?(rate_service)
        next
      end

      if lowest_rate.nil? || rate.rate.to_f < lowest_rate.rate.to_f
        lowest_rate = rate
      end
    end

    raise EasyPost::Error.new('No rates found.') if lowest_rate.nil?

    lowest_rate
  end

  # Gets the lowest stateless rate.
  # You can exclude by having `'!'` as the first element of your optional filter lists
  def self.get_lowest_stateless_rate(stateless_rates, carriers = [], services = [])
    lowest_rate = nil

    carriers = EasyPost::InternalUtilities.normalize_string_list(carriers)
    negative_carriers = []
    carriers_copy = carriers.clone
    carriers_copy.each do |carrier|
      if carrier[0, 1] == '!'
        negative_carriers << carrier[1..]
        carriers.delete(carrier)
      end
    end

    services = EasyPost::InternalUtilities.normalize_string_list(services)
    negative_services = []
    services_copy = services.clone
    services_copy.each do |service|
      if service[0, 1] == '!'
        negative_services << service[1..]
        services.delete(service)
      end
    end

    stateless_rates.each do |rate|
      rate_carrier = rate.carrier.downcase
      if carriers.size.positive? && !carriers.include?(rate_carrier)
        next
      end
      if negative_carriers.size.positive? && negative_carriers.include?(rate_carrier)
        next
      end

      rate_service = rate.service.downcase
      if services.size.positive? && !services.include?(rate_service)
        next
      end
      if negative_services.size.positive? && negative_services.include?(rate_service)
        next
      end

      if lowest_rate.nil? || rate.rate.to_f < lowest_rate.rate.to_f
        lowest_rate = rate
      end
    end

    raise EasyPost::Error.new('No rates found.') if lowest_rate.nil?

    lowest_rate
  end

  # Converts a raw webhook event into an EasyPost object.
  def self.receive_event(raw_input)
    EasyPost::InternalUtilities::Json.convert_json_to_object(JSON.parse(raw_input), EasyPost::Models::EasyPostObject)
  end

  # Get the lowest SmartRate from a list of SmartRate.
  def self.get_lowest_smart_rate(smart_rates, delivery_days, delivery_accuracy)
    valid_delivery_accuracy_values = Set[
      'percentile_50',
      'percentile_75',
      'percentile_85',
      'percentile_90',
      'percentile_95',
      'percentile_97',
      'percentile_99',
    ]
    lowest_smart_rate = nil

    unless valid_delivery_accuracy_values.include?(delivery_accuracy.downcase)
      raise EasyPost::Error.new("Invalid delivery accuracy value, must be one of: #{valid_delivery_accuracy_values}")
    end

    smart_rates.each do |rate|
      next if rate['time_in_transit'][delivery_accuracy] > delivery_days.to_i

      if lowest_smart_rate.nil? || rate['rate'].to_f < lowest_smart_rate['rate'].to_f
        lowest_smart_rate = rate
      end
    end

    if lowest_smart_rate.nil?
      raise EasyPost::Error.new('No rates found.')
    end

    lowest_smart_rate
  end

  # Validate a webhook by comparing the HMAC signature header sent from EasyPost to your shared secret.
  # If the signatures do not match, an error will be raised signifying the webhook either did not originate
  # from EasyPost or the secrets do not match. If the signatures do match, the `event_body` will be returned
  # as JSON.
  def self.validate_webhook(event_body, headers, webhook_secret)
    easypost_hmac_signature = headers['X-Hmac-Signature']

    if easypost_hmac_signature.nil?
      raise EasyPost::Error.new('Webhook received does not contain an HMAC signature.')
    end

    encoded_webhook_secret = webhook_secret.unicode_normalize(:nfkd).encode('utf-8')

    expected_signature = OpenSSL::HMAC.hexdigest('sha256', encoded_webhook_secret, event_body)
    digest = "hmac-sha256-hex=#{expected_signature}"
    unless digest == easypost_hmac_signature
      raise EasyPost::Error.new('Webhook received did not originate from EasyPost or had a webhook secret mismatch.')
    end

    JSON.parse(event_body)
  end
end
