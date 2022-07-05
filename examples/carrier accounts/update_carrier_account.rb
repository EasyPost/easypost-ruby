# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

ca = EasyPost::CarrierAccount.retrieve('ca_...')

ca.description = 'FL Location UPS Account'

ca.credentials['account_number'] = 'B2B2B2'

ca.save

puts ca
