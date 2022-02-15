# frozen_string_literal: true

# Internal utilities helpful for this libraries operation.
module EasyPost::Util
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
    types = {
      'Address' => EasyPost::Address,
      'Batch' => EasyPost::Batch,
      'CarrierAccount' => EasyPost::CarrierAccount,
      'CustomsInfo' => EasyPost::CustomsInfo,
      'CustomsItem' => EasyPost::CustomsItem,
      'Event' => EasyPost::Event,
      'Insurance' => EasyPost::Insurance,
      'Order' => EasyPost::Order,
      'Parcel' => EasyPost::Parcel,
      'PaymentLogReport' => EasyPost::Report,
      'Pickup' => EasyPost::Pickup,
      'PickupRate' => EasyPost::PickupRate,
      'PostageLabel' => EasyPost::PostageLabel,
      'Rate' => EasyPost::Rate,
      'Refund' => EasyPost::Refund,
      'RefundReport' => EasyPost::Report,
      'Report' => EasyPost::Report,
      'ScanForm' => EasyPost::ScanForm,
      'Shipment' => EasyPost::Shipment,
      'TaxIdentifier' => EasyPost::TaxIdentifier,
      'ShipmentInvoiceReport' => EasyPost::Report,
      'ShipmentReport' => EasyPost::Report,
      'Tracker' => EasyPost::Tracker,
      'TrackerReport' => EasyPost::Report,
      'User' => EasyPost::User,
      'Webhook' => EasyPost::Webhook,
    }

    prefixes = {
      'adr' => EasyPost::Address,
      'batch' => EasyPost::Batch,
      'ca' => EasyPost::CarrierAccount,
      'cstinfo' => EasyPost::CustomsInfo,
      'cstitem' => EasyPost::CustomsItem,
      'evt' => EasyPost::Event,
      'hook' => EasyPost::Webhook,
      'ins' => EasyPost::Insurance,
      'order' => EasyPost::Order,
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
    }

    case response
    when Array
      response.map { |i| convert_to_easypost_object(i, api_key, parent) }
    when Hash
      if (cls_name = response[:object])
        cls = types[cls_name]
      elsif response[:id]
        if response[:id].index('_').nil?
          cls = EasyPost::EasyPostObject
        elsif (cls_prefix = response[:id][0..response[:id].index('_')])
          cls = prefixes[cls_prefix[0..-2]]
        end
      elsif response['id']
        if response['id'].index('_').nil?
          cls = EasyPost::EasyPostObject
        elsif (cls_prefix = response['id'][0..response['id'].index('_')])
          cls = prefixes[cls_prefix[0..-2]]
        end
      end

      cls ||= EasyPost::EasyPostObject
      cls.construct_from(response, api_key, parent, name)
    else
      response
    end
  end
end
