# frozen_string_literal: true

class EasyPost::Parcel < EasyPost::Resource
  def self.all(_filters = {}, _api_key = nil)
    raise NotImplementedError.new('Parcel.all not implemented.')
  end
end
