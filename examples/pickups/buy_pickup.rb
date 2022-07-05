# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

pickup = EasyPost::Pickup.retrieve('pickup_...')

pickup.buy(carrier: 'UPS', service: 'Same-Day Pickup')

puts pickup
