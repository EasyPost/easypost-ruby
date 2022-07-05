# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

order = EasyPost::Order.create(
  to_address: {
    id: 'adr_...',
  },
  from_address: {
    id: 'adr_...',
  },
  shipments: [
    { parcel: { predefined_package: 'FedExBox', weight: 10.2 } },
    { parcel: { predefined_package: 'FedExBox', weight: 17.5 } },
  ],
)

puts order
