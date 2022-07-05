# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

customs_item = EasyPost::CustomsItem.create(
  description: 'T-shirt',
  quantity: 1,
  value: 10,
  weight: 5,
  hs_tariff_number: '123456',
  origin_country: 'us',
)

puts customs_item
