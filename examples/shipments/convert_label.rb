# frozen_string_literal: true

# still working on this one
require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

shipment = EasyPost::Shipment.retrieve('shp_...')
shipment.label(file_format: 'ZPL')
