# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

carrier_types = EasyPost::CarrierAccount.types

puts carrier_types
