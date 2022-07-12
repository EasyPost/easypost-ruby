# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

reports = EasyPost::Report.all(
  {
    type: 'payment_log',
    page_size: 4,
    start_date: '2016-01-02',
  },
)

puts reports
