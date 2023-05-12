# frozen_string_literal: true

class EasyPost::Models::Order < EasyPost::Models::EasyPostObject
  # Get the lowest rate of an Order (can exclude by having `'!'` as the first element of your optional filter lists).
  def lowest_rate(carriers = [], services = [])
    EasyPost::Util.get_lowest_object_rate(self, carriers, services)
  end
end
