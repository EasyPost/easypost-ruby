# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

carrier_accounts = EasyPost::CarrierAccount.all

puts carrier_accounts
