class EasyPost::CustomsInfo < EasyPost::Resource
  def self.all(filters={}, api_key=nil)
    raise NotImplementedError.new('CustomsInfo.all not implemented.')
  end
end
