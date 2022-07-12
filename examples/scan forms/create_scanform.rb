# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

scan_form = EasyPost::ScanForm.create(
  {
    shipments: [shipment],
  },
)

puts scan_form
