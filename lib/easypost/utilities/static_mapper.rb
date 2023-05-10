# frozen_string_literal: true

module EasyPost::InternalUtilities::StaticMapper
  BY_PREFIX = {
    'adr' => EasyPost::Models::Address,
  }.freeze

  BY_TYPE = {
    'Address' => EasyPost::Models::Address,
  }.freeze
end
