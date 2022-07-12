# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

batch = EasyPost::Batch.retrieve('batch_...')

batch.remove_shipments(
  {
    shipments: [
      { id: 'shp_...' },
    ],
  },
)

puts batch
