# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

webhooks = EasyPost::Webhook.all

puts webhooks
