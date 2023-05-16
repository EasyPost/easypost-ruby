# frozen_string_literal: true

class EasyPost::Models::Pickup < EasyPost::Models::EasyPostObject
  # Get the lowest rate of a Pickup (can exclude by having `'!'` as the first element of your optional filter lists).
  def lowest_rate(carriers = [], services = [])
    EasyPost::Util.get_lowest_object_rate(self, carriers, services)
  end
end
