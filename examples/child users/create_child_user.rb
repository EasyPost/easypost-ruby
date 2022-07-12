# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

user = EasyPost::User.create(
  {
    name: 'Child Account Name',
  },
)

puts user
