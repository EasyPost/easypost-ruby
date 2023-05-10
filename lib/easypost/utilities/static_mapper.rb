# frozen_string_literal: true

require_relative '../models'

module EasyPost::InternalUtilities::StaticMapper
  BY_PREFIX = {
    'ak' => EasyPost::Models::ApiKey,
    'adr' => EasyPost::Models::Address,
    'batch' => EasyPost::Models::Batch,
    'ca' => EasyPost::Models::CarrierAccount,
  }.freeze

  BY_TYPE = {
    'ApiKey' => EasyPost::Models::ApiKey,
    'Address' => EasyPost::Models::Address,
    'Batch' => EasyPost::Models::Batch,
    'CarrierAccount' => EasyPost::Models::CarrierAccount,
  }.freeze
end
