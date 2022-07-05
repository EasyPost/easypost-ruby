# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

ca = EasyPost::CarrierAccount.create(
  type: 'UpsAccount',
  description: 'NY Location UPS Account',
  reference: 'my-reference',
  credentials: {
    account_number: 'A1A1A1',
    user_id: 'USERID',
    password: 'PASSWORD',
    access_license_number: 'ALN',
  },
)

puts ca
