# frozen_string_literal: true

class EasyPost::Rate < EasyPost::Resource
  def self.all(_filters = {}, _api_key = nil)
    raise NotImplementedError.new('Rate.all not implemented.')
  end
end
