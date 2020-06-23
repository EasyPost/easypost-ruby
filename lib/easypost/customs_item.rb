module EasyPost
  class CustomsItem < Resource

    def self.all(filters={}, api_key=nil)
      raise NotImplementedError.new('CustomsItem.all not implemented.')
    end

  end
end
