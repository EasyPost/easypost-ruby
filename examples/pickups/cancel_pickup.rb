# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

pickup = EasyPost::Pickup.retrieve('pickup_...')

pickup.cancel

puts pickup
