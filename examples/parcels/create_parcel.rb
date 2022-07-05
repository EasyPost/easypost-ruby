# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

parcel = EasyPost::Parcel.create(
  length: 20.2,
  width: 10.9,
  height: 5,
  weight: 65.9,
)

puts parcel
