# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

report = EasyPost::Report.create(
  type: 'payment_log',
  start_date: '2016-10-01',
  end_date: '2016-10-31',
)

puts report
