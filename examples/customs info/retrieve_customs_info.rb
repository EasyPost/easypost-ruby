# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

customs_info = EasyPost::CustomsInfo.retrieve('cstinfo_...')

puts customs_info
