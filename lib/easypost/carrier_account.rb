class EasyPost::CarrierAccount < EasyPost::Resource
  def self.types
    EasyPost::CarrierType.all
  end
end
