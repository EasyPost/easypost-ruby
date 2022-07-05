require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

trackers = EasyPost::Tracker.all(
  page_size: 2,
  start_datetime: "2016-01-02T08:50:00Z"
)