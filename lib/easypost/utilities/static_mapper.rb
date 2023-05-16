# frozen_string_literal: true

require_relative '../models'

module EasyPost::InternalUtilities::StaticMapper
  BY_PREFIX = {
    'ak' => EasyPost::Models::ApiKey,
    'adr' => EasyPost::Models::Address,
    'batch' => EasyPost::Models::Batch,
    'ca' => EasyPost::Models::CarrierAccount,
    'es' => EasyPost::Models::EndShipper,
    'evt' => EasyPost::Models::Event,
    'ins' => EasyPost::Models::Insurance,
    'rate' => EasyPost::Models::Rate,
    'pickup' => EasyPost::Models::Pickup,
    'pickuprate' => EasyPost::Models::PickupRate,
    'pl' => EasyPost::Models::PostageLabel,
    'user' => EasyPost::Models::User,
  }.freeze

  BY_TYPE = {
    'ApiKey' => EasyPost::Models::ApiKey,
    'Address' => EasyPost::Models::Address,
    'Batch' => EasyPost::Models::Batch,
    'CarrierAccount' => EasyPost::Models::CarrierAccount,
    'EndShipper' => EasyPost::Models::EndShipper,
    'Event' => EasyPost::Models::Event,
    'payload' => EasyPost::Models::Payload,
    'Insurance' => EasyPost::Models::Insurance,
    'Rate' => EasyPost::Models::Rate,
    'Pickup' => EasyPost::Models::Pickup,
    'PickupRate' => EasyPost::Models::PickupRate,
    'PostageLabel' => EasyPost::Models::PostageLabel,
    'User' => EasyPost::Models::User,
  }.freeze
end
