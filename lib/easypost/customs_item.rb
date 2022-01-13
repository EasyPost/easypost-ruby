# frozen_string_literal: true

class EasyPost::CustomsItem < EasyPost::Resource
  def self.all(_filters = {}, _api_key = nil)
    raise NotImplementedError.new('CustomsItem.all not implemented.')
  end
end
