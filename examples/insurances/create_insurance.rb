# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

insurance = EasyPost::Insurance.create(
  to_address: {
    street1: '417 MONTGOMERY ST',
    street2: 'FLOOR 5',
    city: 'SAN FRANCISCO',
    state: 'CA',
    zip: '94104',
    country: 'US',
    company: 'EasyPost',
    phone: '415-123-4567',
  },
  from_address: {
    street1: '123 TEST ST',
    city: 'SAN FRANCISCO',
    state: 'CA',
    zip: '94104',
    country: 'US',
    company: 'EasyPost',
    phone: '123-456-7890',
  },
  tracking_code: '9400110898825022579493',
  carrier: 'USPS',
  amount: '100.00',
  reference: 'insuranceRef1',
)

puts insurance
