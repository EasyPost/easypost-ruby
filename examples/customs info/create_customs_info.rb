# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

customs_info = EasyPost::CustomsInfo.create(
  eel_pfc: 'NOEEI 30.37(a)',
  customs_certify: true,
  customs_signer: 'Steve Brule',
  contents_type: 'merchandise',
  contents_explanation: '',
  restriction_type: 'none',
  restriction_comments: '',
  non_delivery_option: 'abandon',
  customs_items: [
    customs_item, {
      description: 'Sweet shirts',
      quantity: 2,
      weight: 11,
      value: 23,
      hs_tariff_number: '654321',
      origin_country: 'US',
    },
  ],
)

puts customs_info
