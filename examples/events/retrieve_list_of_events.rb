# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

events = EasyPost::Event.all(
  page_size: 5,
)

puts events
