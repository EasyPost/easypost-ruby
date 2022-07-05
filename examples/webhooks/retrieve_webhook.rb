# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_TEST_API_KEY']

webhook = EasyPost::Webhook.retrieve('hook_...')

puts webhook
