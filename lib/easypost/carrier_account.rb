# frozen_string_literal: true

# A CarrierAccount encapsulates your credentials with the carrier.
class EasyPost::CarrierAccount < EasyPost::Resource
  # Retrieve a list of available CarrierAccount types for the authenticated User.
  def self.types
    EasyPost::CarrierType.all
  end
end
