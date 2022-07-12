# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

carrier_account = EasyPost::CarrierAccount.retrieve('ca_...')
carrier_account.description = 'FL Location UPS Account'

carrier_account.credentials['account_number'] = 'B2B2B2'
carrier_account.save

puts carrier_account
