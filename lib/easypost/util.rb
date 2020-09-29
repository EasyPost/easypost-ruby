module EasyPost
  module Util
    def self.objects_to_ids(obj)
      case obj
      when Resource
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
        'Address' => Address,
        'ScanForm' => ScanForm,
        'CustomsItem' => CustomsItem,
        'CustomsInfo' => CustomsInfo,
        'Parcel' => Parcel,
        'Shipment' => Shipment,
        'Rate' => Rate,
        'Refund' => Refund,
        'Event' => Event,
        'Batch' => Batch,
        'Tracker' => Tracker,
        'Item' => Item,
        'Insurance' => Insurance,
        'Order' => Order,
        'Pickup' => Pickup,
        'PickupRate' => PickupRate,
        'PostageLabel' => PostageLabel,
        'Printer' => Printer,
        'PrintJob' => PrintJob,
        'CarrierAccount' => CarrierAccount,
        'User' => User,
        'Report' => Report,
        'ShipmentReport' => Report,
        'PaymentLogReport' => Report,
        'TrackerReport' => Report,
        'RefundReport' => Report,
        'ShipmentInvoiceReport' => Report,
        'Webhook' => Webhook
      }

      prefixes = {
        'adr' => Address,
        'sf' => ScanForm,
        'cstitem' => CustomsItem,
        'cstinfo' => CustomsInfo,
        'prcl' => Parcel,
        'shp' => Shipment,
        'rate' => Rate,
        'rfnd' => Refund,
        'evt' => Event,
        'batch' => Batch,
        'trk' => Tracker,
        'item' => Item,
        'ins' => Insurance,
        'order' => Order,
        'pickup' => Pickup,
        'pickuprate' => PickupRate,
        'pl' => PostageLabel,
        'printer' => Printer,
        'printjob' => PrintJob,
        'ca' => CarrierAccount,
        'user' => User,
        'shprep' => Report,
        'plrep' => Report,
        'trkrep' => Report,
        'refrep' => Report,
        'shpinvrep' => Report,
        'hook' => Webhook
      }

      case response
      when Array
        return response.map { |i| convert_to_easypost_object(i, api_key, parent) }
      when Hash
        if cls_name = response[:object]
          cls = types[cls_name]
        elsif response[:id]
          if response[:id].index('_').nil?
            cls = EasyPostObject
          elsif cls_prefix = response[:id][0..response[:id].index('_')]
            cls = prefixes[cls_prefix[0..-2]]
          end
        elsif response['id']
          if response['id'].index('_').nil?
            cls = EasyPostObject
          elsif cls_prefix = response['id'][0..response['id'].index('_')]
            cls = prefixes[cls_prefix[0..-2]]
          end
        end

        cls ||= EasyPostObject
        return cls.construct_from(response, api_key, parent, name)
      else
        return response
      end
    end
  end
end
