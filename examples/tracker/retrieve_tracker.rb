require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

EasyPost::Tracker.create({
  tracking_code: "EZ1000000001",
  carrier: "USPS"
})

tracker = EasyPost::Tracker.retrieve('trk_2fc89a1e2359460e862885b739de8038')
puts tracker
