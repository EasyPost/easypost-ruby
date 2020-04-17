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

    def self.symbolize_names(obj)
      case obj
      when Hash
        result = {}
        obj.each do |k, v|
          k = (k.to_sym rescue k) || k
          obj[k] = symbolize_names(v)
        end
        return result
      when Array
        return obj.map { |v| symbolize_names(v) }
      else
        return obj
      end
    end

    def self.url_encode(key)
      CGI.escape(key.to_s)
    end

    def self.flatten_params(params, parent_key=nil)
      result = []
      if params.is_a?(Hash)
        params.each do |k, v|
          calculated_key = parent_key ? "#{parent_key}[#{url_encode(k)}]" : url_encode(k)
          if v.is_a?(Hash) or v.is_a?(Array)
            result += flatten_params(v, calculated_key)
          else
            result << [calculated_key, v]
          end
        end
      elsif params.is_a?(Array)
        params.each_with_index do |v, i|
          calculated_key = parent_key ? "#{parent_key}[#{i}]" : i
          if v.is_a?(Hash) or v.is_a?(Array)
            result += flatten_params(v, calculated_key)
          else
            result << [calculated_key, v]
          end
        end
      end
      return result
    end
  end
end
