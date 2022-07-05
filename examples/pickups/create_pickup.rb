# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

pickup = EasyPost::Pickup.create(
  address: {
    id: 'adr_...',
  },
  shipment: {
    id: 'shp_...',
  },
  reference: 'my-first-pickup',
  min_datetime: DateTime.now,
  max_datetime: DateTime.now + 14_400,
  is_account_address: false,
  instructions: 'Special pickup instructions',
)

puts pickup
