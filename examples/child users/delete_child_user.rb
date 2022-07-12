# frozen_string_literal: true

require 'easypost'

EasyPost.api_key = ENV['EASYPOST_API_KEY']

user = EasyPost::User.retrieve('user_...')

user.delete

puts user
