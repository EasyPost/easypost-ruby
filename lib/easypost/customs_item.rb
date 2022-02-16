# frozen_string_literal: true

# A CustomsItem object describes goods for international shipment and should be created then included in a CustomsInfo object.
class EasyPost::CustomsItem < EasyPost::Resource
  # Retrieve a list of CustomsItem objects
  def self.all
    raise NotImplementedError.new('CustomsItem.all not implemented.')
  end
end
