# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

address = EasyPost::Address.create(
  street1: '417 MONTGOMERY ST',
  street2: 'FLOOR 5',
  city: 'SAN FRANCISCO',
  state: 'CA',
  zip: '94104',
  country: 'US',
  company: 'EasyPost',
  phone: '415-123-4567',
)

puts address
