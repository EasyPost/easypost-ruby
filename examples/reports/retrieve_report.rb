# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

report = EasyPost::Report.retrieve('<REPORT_ID>')

puts report
