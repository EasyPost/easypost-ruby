# frozen_string_literal: true

# Internal utilities helpful for this libraries operation.
module EasyPost::Util
  attr_accessor :os_name, :os_version, :os_arch

  BY_PREFIX = {
    'ak' => EasyPost::ApiKey,
    'adr' => EasyPost::Address,
    'bank' => EasyPost::PaymentMethod,
    'batch' => EasyPost::Batch,
    'brd' => EasyPost::Brand,
    'ca' => EasyPost::CarrierAccount,
    'card' => EasyPost::PaymentMethod,
    'cstinfo' => EasyPost::CustomsInfo,
    'cstitem' => EasyPost::CustomsItem,
    'es' => EasyPost::EndShipper,
    'evt' => EasyPost::Event,
    'hook' => EasyPost::Webhook,
    'ins' => EasyPost::Insurance,
    'order' => EasyPost::Order,
    'payload' => EasyPost::Payload,
    'pickup' => EasyPost::Pickup,
    'pickuprate' => EasyPost::PickupRate,
    'pl' => EasyPost::PostageLabel,
    'plrep' => EasyPost::Report,
    'prcl' => EasyPost::Parcel,
    'rate' => EasyPost::Rate,
    'refrep' => EasyPost::Report,
    'rfnd' => EasyPost::Refund,
    'sf' => EasyPost::ScanForm,
    'shp' => EasyPost::Shipment,
    'shpinvrep' => EasyPost::Report,
    'shprep' => EasyPost::Report,
    'trk' => EasyPost::Tracker,
    'trkrep' => EasyPost::Report,
    'user' => EasyPost::User,
  }.freeze

  BY_TYPE = {
    'Address' => EasyPost::Address,
    'ApiKey' => EasyPost::ApiKey,
    'BankAccount' => EasyPost::PaymentMethod,
    'Batch' => EasyPost::Batch,
    'Brand' => EasyPost::Brand,
    'CarbonOffset' => EasyPost::CarbonOffset,
    'CarrierAccount' => EasyPost::CarrierAccount,
    'CreditCard' => EasyPost::PaymentMethod,
    'CustomsInfo' => EasyPost::CustomsInfo,
    'CustomsItem' => EasyPost::CustomsItem,
    'EndShipper' => EasyPost::EndShipper,
    'Event' => EasyPost::Event,
    'Insurance' => EasyPost::Insurance,
    'Order' => EasyPost::Order,
    'Parcel' => EasyPost::Parcel,
    'PaymentLogReport' => EasyPost::Report,
    'Pickup' => EasyPost::Pickup,
    'PickupRate' => EasyPost::PickupRate,
    'PostageLabel' => EasyPost::PostageLabel,
    'Rate' => EasyPost::Rate,
    'Referral' => EasyPost::Beta::Referral,
    'Refund' => EasyPost::Refund,
    'RefundReport' => EasyPost::Report,
    'Report' => EasyPost::Report,
    'ScanForm' => EasyPost::ScanForm,
    'Shipment' => EasyPost::Shipment,
    'ShipmentInvoiceReport' => EasyPost::Report,
    'ShipmentReport' => EasyPost::Report,
    'TaxIdentifier' => EasyPost::TaxIdentifier,
    'Tracker' => EasyPost::Tracker,
    'TrackerReport' => EasyPost::Report,
    'User' => EasyPost::User,
    'Webhook' => EasyPost::Webhook,
  }.freeze

  def self.os_name
    case RUBY_PLATFORM
    when /linux/i
      'Linux'
    when /darwin/i
      'Darwin'
    when /cygwin|mswin|mingw|bccwin|wince|emx/i
      'Windows'
    else
      'Unknown'
    end
  end

  def self.os_version
    Gem::Platform.local.version
  end

  def self.os_arch
    Gem::Platform.local.cpu
  end

  # Form-encode a multi-layer dictionary to a one-layer dictionary.
  def self.form_encode_params(hash, parent_keys = [], parent_dict = {})
    result = parent_dict or {}
    keys = parent_keys or []

    hash.each do |key, value|
      if value.instance_of?(Hash)
        keys << key
        result = form_encode_params(value, keys, result)
      else
        dict_key = build_dict_key(keys + [key])
        result[dict_key] = value
      end
    end
    result
  end

  # Build a dict key from a list of keys.
  # Example: [code, number] -> code[number]
  def self.build_dict_key(keys)
    result = keys[0].to_s

    keys[1..].each do |key|
      result += "[#{key}]"
    end

    result
  end

  # Converts an object to an object ID.
  def self.objects_to_ids(obj)
    case obj
    when EasyPost::Resource
      { id: obj.id }
    when Hash
      result = {}
      obj.each { |k, v| result[k] = objects_to_ids(v) unless v.nil? }
      result
    when Array
      obj.map { |v| objects_to_ids(v) }
    else
      obj
    end
  end

  # Normalizes a list of strings.
  def self.normalize_string_list(lst)
    lst = lst.is_a?(String) ? lst.split(',') : Array(lst)
    lst.map(&:to_s).map(&:downcase).map(&:strip)
  end

  # Convert data to an EasyPost Object.
  def self.convert_to_easypost_object(response, api_key, parent = nil, name = nil)
    case response
    when Array
      response.map { |i| convert_to_easypost_object(i, api_key, parent) }
    when Hash
      # Determine class based on the "object" key in the JSON response
      cls_name = response[:object] || response['object']
      if cls_name
        # Use the "object" key value to look up the class
        cls = BY_TYPE[cls_name]
      else
        # Fallback to determining class based on the "id" prefix in the JSON response
        id = response[:id] || response['id']
        if id.nil? || id.index('_').nil?
          # ID not present or prefix not present (ID malformed)
          cls = EasyPost::EasyPostObject
        else
          # Parse the prefix from the ID and use it to look up the class
          cls_prefix = id[0..id.index('_')][0..-2]
          cls = BY_PREFIX[cls_prefix]
        end
      end
      # Fallback to using the generic class if other determination methods fail (or class lookup produced no results)
      cls ||= EasyPost::EasyPostObject
      cls.construct_from(response, api_key, parent, name)
    else
      # response is neither a Hash nor Array (used mostly when dealing with final values like strings, booleans, etc.)
      response
    end
  end

  # Gets the lowest rate of an EasyPost object such as a Shipment, Order, or Pickup.
  # You can exclude by having `'!'` as the first element of your optional filter lists
  def self.get_lowest_object_rate(easypost_object, carriers = [], services = [], rates_key = 'rates')
    lowest_rate = nil

    carriers = EasyPost::Util.normalize_string_list(carriers)
    negative_carriers = []
    carriers_copy = carriers.clone
    carriers_copy.each do |carrier|
      if carrier[0, 1] == '!'
        negative_carriers << carrier[1..]
        carriers.delete(carrier)
      end
    end

    services = EasyPost::Util.normalize_string_list(services)
    negative_services = []
    services_copy = services.clone
    services_copy.each do |service|
      if service[0, 1] == '!'
        negative_services << service[1..]
        services.delete(service)
      end
    end

    easypost_object[rates_key].each do |rate|
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

    carriers = EasyPost::Util.normalize_string_list(carriers)
    negative_carriers = []
    carriers_copy = carriers.clone
    carriers_copy.each do |carrier|
      if carrier[0, 1] == '!'
        negative_carriers << carrier[1..]
        carriers.delete(carrier)
      end
    end

    services = EasyPost::Util.normalize_string_list(services)
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
end
