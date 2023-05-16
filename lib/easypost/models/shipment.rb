# frozen_string_literal: true

class EasyPost::Models::Shipment < EasyPost::Models::EasyPostObject
  # Get the lowest rate of a Shipment (can exclude by having `'!'` as the first element of your optional filter lists).
  def lowest_rate(carriers = [], services = [])
    EasyPost::Util.get_lowest_object_rate(self, carriers, services)
  end

  # Get the lowest smartrate of a Shipment.
  def lowest_smartrate(delivery_days, delivery_accuracy)
    smartrates = get_smartrates
    EasyPost::Util.get_lowest_smartrate(smartrates, delivery_days, delivery_accuracy)
  end
end
