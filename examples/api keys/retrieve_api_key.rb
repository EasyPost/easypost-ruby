# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

api_keys = EasyPost::User.all_api_keys

puts api_keys
