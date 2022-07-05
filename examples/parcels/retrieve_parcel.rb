require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

EasyPost::Parcel.create(
  length: 20.2,
  width: 10.9,
  height: 5,
  weight: 65.9
)

parcel = EasyPost::Parcel.retrieve("prcl_466d3363548a491ab4b89672a20f7ed0")

puts parcel