# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

carrier_account = EasyPost::CarrierAccount.retrieve('ca_...')

puts carrier_account
