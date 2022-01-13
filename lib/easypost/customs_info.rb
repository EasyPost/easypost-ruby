# frozen_string_literal: true

class EasyPost::CustomsInfo < EasyPost::Resource
  def self.all(_filters = {}, _api_key = nil)
    raise NotImplementedError.new('CustomsInfo.all not implemented.')
  end
end
