module EasyPost::Util
  def self.objects_to_ids(obj)
    case obj
    when EasyPost::Resource
      return {:id => obj.id}
    when Hash
      result = {}
      obj.each { |k, v| result[k] = objects_to_ids(v) unless v.nil? }
      return result
    when Array
      return obj.map { |v| objects_to_ids(v) }
    else
      return obj
    end
  end

  def self.normalize_string_list(lst)
    lst = lst.is_a?(String) ? lst.split(',') : Array(lst)
    lst.map(&:to_s).map(&:downcase).map(&:strip)
  end

  def self.convert_to_easypost_object(response, api_key, parent=nil, name=nil)
    types = {
      'Address' => EasyPost::Address,
      'ScanForm' => EasyPost::ScanForm,
      'CustomsItem' => EasyPost::CustomsItem,
      'CustomsInfo' => EasyPost::CustomsInfo,
      'Parcel' => EasyPost::Parcel,
      'Shipment' => EasyPost::Shipment,
      'Rate' => EasyPost::Rate,
      'Refund' => EasyPost::Refund,
      'Event' => EasyPost::Event,
      'Batch' => EasyPost::Batch,
      'Tracker' => EasyPost::Tracker,
      'Item' => EasyPost::Item,
      'Insurance' => EasyPost::Insurance,
      'Order' => EasyPost::Order,
      'Pickup' => EasyPost::Pickup,
      'PickupRate' => EasyPost::PickupRate,
      'PostageLabel' => EasyPost::PostageLabel,
      'Printer' => EasyPost::Printer,
      'PrintJob' => EasyPost::PrintJob,
      'CarrierAccount' => EasyPost::CarrierAccount,
      'User' => EasyPost::User,
      'Report' => EasyPost::Report,
      'ShipmentReport' => EasyPost::Report,
      'PaymentLogReport' => EasyPost::Report,
      'TrackerReport' => EasyPost::Report,
      'RefundReport' => EasyPost::Report,
      'ShipmentInvoiceReport' => EasyPost::Report,
      'Webhook' => EasyPost::Webhook
    }

    prefixes = {
      'adr' => EasyPost::Address,
      'sf' => EasyPost::ScanForm,
      'cstitem' => EasyPost::CustomsItem,
      'cstinfo' => EasyPost::CustomsInfo,
      'prcl' => EasyPost::Parcel,
      'shp' => EasyPost::Shipment,
      'rate' => EasyPost::Rate,
      'rfnd' => EasyPost::Refund,
      'evt' => EasyPost::Event,
      'batch' => EasyPost::Batch,
      'trk' => EasyPost::Tracker,
      'item' => EasyPost::Item,
      'ins' => EasyPost::Insurance,
      'order' => EasyPost::Order,
      'pickup' => EasyPost::Pickup,
      'pickuprate' => EasyPost::PickupRate,
      'pl' => EasyPost::PostageLabel,
      'printer' => EasyPost::Printer,
      'printjob' => EasyPost::PrintJob,
      'ca' => EasyPost::CarrierAccount,
      'user' => EasyPost::User,
      'shprep' => EasyPost::Report,
      'plrep' => EasyPost::Report,
      'trkrep' => EasyPost::Report,
      'refrep' => EasyPost::Report,
      'shpinvrep' => EasyPost::Report,
      'hook' => EasyPost::Webhook
    }

    case response
    when Array
      return response.map { |i| convert_to_easypost_object(i, api_key, parent) }
    when Hash
      if cls_name = response[:object]
        cls = types[cls_name]
      elsif response[:id]
        if response[:id].index('_').nil?
          cls = EasyPost::EasyPostObject
        elsif cls_prefix = response[:id][0..response[:id].index('_')]
          cls = prefixes[cls_prefix[0..-2]]
        end
      elsif response['id']
        if response['id'].index('_').nil?
          cls = EasyPost::EasyPostObject
        elsif cls_prefix = response['id'][0..response['id'].index('_')]
          cls = prefixes[cls_prefix[0..-2]]
        end
      end

      cls ||= EasyPost::EasyPostObject
      return cls.construct_from(response, api_key, parent, name)
    else
      return response
    end
  end
end
