# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

webhook = EasyPost::Webhook.create(
  { url: 'http://example.com' },
)

puts webhook
